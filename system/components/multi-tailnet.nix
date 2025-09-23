{
  pkgs,
  lib,
  config,
  ...
}:
# work in progress
# https://uint.one/posts/all-internet-over-wireguard-using-systemd-networkd-on-nixos/
# https://jamesguthrie.ch/blog/multi-tailnet-unlocking-access-to-multiple-tailscale-networks/
with lib;
{
  options = {
    services.tailscale.multi-tailnet = {
      enable = mkEnable "multi-tailnet";

      tailnets =
        let
          tailnet = types.submodule {
            options = {
              authKeyFile = types.nullOr types.path;
            };
          };
        in
        mkOption {
          type = attrsOf tailnet;
        };
    };
  };

  config =
    let
      cfg = config.services.tailscale.multi-tailnet;
      mkService = tailnet: {
      };
    in
    mkIf cfg.enable {
      services.tailscale.enable = false;

      systemd.services."container@wgcontainer" = {
        requires = [
          "lo@wgns.service"
          "veth@wgns.service"
          "wg@wgns.service"
        ];
        after = [
          "lo@wgns.service"
          "veth@wgns.service"
          "wg@wgns.service"
        ];
      };

      containers = {
        wgcontainer = {
          specialArgs = { inherit inputs; };
          autoStart = true;

          extraFlags = [ "--network-namespace-path=/run/netns/wgns" ];

          config =
            { ... }:
            {
              networking.useDHCP = false;
              networking.useNetworkd = true;
              networking.useHostResolvConf = lib.mkForce false;

              networking.firewall.enable = false;
              networking.nftables = {
                enable = true;

                ruleset = ''
                  table inet nat {
                    chain postrouting {
                      type nat hook postrouting priority 100; policy accept;

                      iiftype ether oifname "ve-wgns" masquerade
                    }
                    chain prerouting {
                      type nat hook prerouting priority -100; policy accept;

                      iifname ether tcp dport { ssh, http } dnat ip to ${natIpv4Ns}
                    }
                  }
                '';
              };
            };
        };
      };
    };

}
