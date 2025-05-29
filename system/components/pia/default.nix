{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
with pkgs; {
  imports = [
    ../network-connected.nix
  ];
  options.services.pia-vpn = {
    region = lib.mkOption {
      type = lib.types.str;
    };
  };
  config = {
    environment.systemPackages = [
      curl
      wireguard-tools
      iproute2
      _1password-cli
    ];

    services.resolved = {
      enable = true;
      dnsovertls = "opportunistic";
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
      users = [];
      services = ["wg-pia-setup.service"];
    };

    systemd.services = {
      wg-pia-setup = {
        after = ["network-connected.service"];
        wantedBy = ["multi-user.target"];
        path = [
          curl
          wireguard-tools
          iproute2
          nftables
        ];
        script = let
          auth = data.pia.authUserPass;
        in "${nushell}/bin/nu ${./pia-setup.nu} ${pkgs.asOpnixPath "pia/username"} ${pkgs.asOpnixPath "pia/password"} ${config.services.pia-vpn.region} ${./ca.rsa.4096.crt}";
        serviceConfig = {
          Type = "oneshot";
        };
      };
    };

    networking = {
      nftables.enable = true;

      startupOnlineCheckUrls = ["https://serverlist.piaservers.net/vpninfo/servers/v6" "https://www.privateinternetaccess.com"];
    };
  };
}
