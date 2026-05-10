{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ../network-connected.nix
  ];
  options.services.pia-vpn = with lib; {
    enable = mkEnableOption "pia vpn";
    region = mkOption {
      type = types.str;
    };
    rerouteExitNodeTraffic = mkOption {
      type = types.bool;
      default = false;
    };
    forwardingPort = mkOption {
      type = types.nullOr types.number;
      default = null;
    };
  };
  config =
    let
      cfg = config.services.pia-vpn;
    in
    lib.mkIf cfg.enable {
      environment.systemPackages = with pkgs; [
        curl
        wireguard-tools
        iproute2
        _1password-cli
      ];

      services.resolved = {
        enable = true;
        settings = {
          Resolve = {
            DNSOverTLS = lib.mkDefault "opportunistic";
          };
        };
      };

      opnix = {
        secrets = [
          {
            path = "pia/username";
            reference = "op://Services/Private Internet Access/username";
          }
          {
            path = "pia/password";
            reference = "op://Services/Private Internet Access/password";
          }
        ];
        users = [ ];
        services = [ "wg-pia-setup.service" ];
      };

      systemd.services = with pkgs; {
        wg-pia-setup = {
          after = [ "network-connected.service" ];
          wantedBy = [ "multi-user.target" ];
          path = [
            curl
            wireguard-tools
            iproute2
            nftables
          ];
          script = "${nushell}/bin/nu ${./pia-setup.nu} ${pkgs.asOpnixPath "pia/username"} ${pkgs.asOpnixPath "pia/password"} ${cfg.region} ${./ca.rsa.4096.crt} ${lib.boolToString cfg.rerouteExitNodeTraffic}";
          serviceConfig = {
            RemainAfterExit = true;
            Type = "oneshot";
          };
        };
        wg-pia-forwarding =
          if cfg.forwardingPort != null then
            {
              enable = true;
              requires = [ "wg-pia-setup.service" ];
              wantedBy = [ "multi-user.target" ];
              path = [
                curl
                iproute2
                nftables
              ];
              script = "${nushell}/bin/nu ${./pia-setup.nu} forwarding ${./ca.rsa.4096.crt} ${toString cfg.forwardingPort}";
            }
          else
            { };
      };

      networking = {
        nftables.enable = true;
      };
    };
}
