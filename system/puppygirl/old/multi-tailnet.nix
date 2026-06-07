{
  pkgs,
  lib,
  config,
  ...
}:
# work in progress
# https://uint.one/posts/all-internet-over-wireguard-using-systemd-networkd-on-nixos/
# https://jamesguthrie.ch/blog/multi-tailnet-unlocking-access-to-multiple-tailscale-networks/

{
  options = with lib; {
    services.multi-tailnet = {
      enable = mkEnableOption "multi tailnet";

      tailnets =
        let
          tailnet = {
            options = {
              authKeyFile = mkOption {
                type = types.nullOr types.path;
              };
              ipv4Address = mkOption {
                type = types.str;
              };
              ipv4AddressSub = mkOption {
                type = types.str;
              };
              ipv4AddressDns = mkOption {
                type = types.str;
              };
            };
          };
        in
        mkOption {
          type = types.attrsOf (types.submodule tailnet);
        };
    };
  };

  config =
    with pkgs;
    let
      cfg = config.services.multi-tailnet;
      mkTailnet = tailnet: tscfg: {
        name = "tailscale-tailnet-autoconnect-${tailnet}";
        value = {
          after = [
            "tailnet-ns@${tailnet}.service"
            "tailscaled@${tailnet}.service"
          ];
          requires = [
            "network-online.target"
          ];
          unitConfig.JoinsNamespaceOf = "tailnet-ns@${tailnet}.service";
          path = [
            tailscale
          ];
          serviceConfig = {
            PrivateNetwork = true;
            Type = "oneshot";
            ExecStart = writeNushellScript "autoconnect-${tailnet}-start" "tailscale --socket /tmp/tstail${tailnet}/tstail.socket up --accept-routes --auth-key file:${tscfg.authKeyFile}";
            ExecStopPost = writeNushellScript "autoconnect-${tailnet}-stop" "tailscale --socket /tmp/tstail${tailnet}/tstail.socket down";
          };
        };
      };
      mkAddrFile = tailnet: tscfg: {
        name = "tailnet-addrs-${tailnet}";
        value = {
          text = builtins.toJSON {
            addr = tscfg.ipv4Address;
            subaddr = tscfg.ipv4AddressSub;
            dnsaddr = tscfg.ipv4AddressDns;
          };
          target = "tailnets/${tailnet}/addrs";
        };
      };
      mkResolvConf = tailnet: tscfg: {
        name = "tailnet-netns-${tailnet}";
        value = {
          text = ''
            namespace 1.1.1.1
            namespace 1.0.0.1
          '';
          target = "netns/${tailnet}/resolv.conf";
        };
      };
    in
    with lib;
    mkIf cfg.enable {
      systemd.network.config.networkConfig = {
        IPv4Forwarding = true;
        IPv6Forwarding = true;
      };

      environment.etc = mapAttrs' mkAddrFile cfg.tailnets // mapAttrs' mkResolvConf cfg.tailnets;

      services.resolved.settings.Resolve = {
        DNSStubListenerExtra = map (tscfg: tscfg.ipv4Address) (builtins.attrValues cfg.tailnets);
      };

      systemd.services = (mapAttrs' mkTailnet cfg.tailnets) // {
        "tailnet-ns@" = {
          before = [ "network.target" ];
          path = [
            iproute2
            util-linux
            nftables
          ];
          serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = true;
            PrivateNetwork = true;
            ExecStart = "${writeNushellScript "netns-up" ''
              def main [name: string] {
                              ip netns add $name
                              umount $"/var/run/netns/($name)"
                              mount --bind /proc/self/ns/net $"/var/run/netns/($name)"
                              }''} %I";
            ExecStopPost = "${writeNushellScript "netns-down" ''
              def main [name: string] {
                              ip netns del $name
                              }''} %I";
            PrivateMounts = false;
          };
        };
        "tailnet-dev@" = {
          before = [ "network.target" ];
          bindsTo = [ "tailnet-ns@.service" ];
          after = [ "tailnet-ns@.service" ];
          path = [
            iproute2
            util-linux
            nftables
            nushell
            procps
          ];
          serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = true;
            ExecStart = "${writeNushellScript "dev-setup" ''
              def main [name: string] {
              let hosteth = $"veth-host-($name)";
              let subeth = $"veth-sub-($name)";
              print "hiihihihihi" -e
              ip -n $name link set dev lo up
              ip link add $hosteth type veth peer name $subeth
              ip link set $subeth netns $name
              sysctl -w net.ipv6.conf.all.accept_ra=2
              sysctl -w net.ipv6.conf.default.accept_ra=2
              sysctl -w net.ipv6.conf.($hosteth).accept_ra=2
              ip netns exec $name sysctl -w net.ipv6.conf.($subeth).accept_ra=2
              ip token set :: dev $hosteth
              ip link set dev $hosteth up
              ip -n $name token set :: dev $subeth
              ip -n $name link set dev $subeth up
              print "fetching host address"
              let hostaddr = sys net | where {$in.name == $hosteth} | get 0.ip.0.address;
              $subeth | print
              print "fetching sub address"
              let subaddr = ip netns exec $name nu -c $'sys net | where {$in.name == "($subeth)"} | get 0.ip.0.address'
              let v4 = open $"/etc/tailnets/($name)/addrs" | from json;
              print $"($hostaddr) ($subaddr) ($v4.addr) ($v4.subaddr)"
              print $"flushed host"
              ip addr add $"($v4.addr)/24" dev $hosteth
              ip -n $name addr add $"($v4.subaddr)/24" dev $subeth
              ip -n $name route add default via $v4.addr dev $subeth
              ip -6 -n $name route add default via $hostaddr dev $subeth
              ip -6 route add $subaddr dev $hosteth
              print $"added route"
              $"
              table inet filter {
                chain tailnet($name) {
                  type filter hook forward priority 0; policy drop;
                  oifname "($hosteth)" accept
                  iifname "($hosteth)" accept
                }
              }

              table ip nat {
                chain tailnet($name) {
                  type nat hook postrouting priority 100;
                  ip saddr ($v4.addr)/24 oifname != "($hosteth)" masquerade;
                  ip saddr ($v4.addr)/24 oifname != "($hosteth)" meta nftrace set 1;
                }
              }
              table ip6 nat {
                chain tailnet($name) {
                  type nat hook postrouting priority 100;
                  ip6 saddr ($hostaddr) oifname != "($hosteth)" masquerade;
                  ip6 saddr ($hostaddr) oifname != "($hosteth)" meta nftrace set 1;
                }
              }
              " | nft -f-
              $"
              table inet nat {
                chain tailnet {
                  type nat hook postrouting priority 100;
                  meta nftrace set 1;
                  iifname "($subeth)" oifname "tailscale0" masquerade
                }
              }
              " | ip netns exec $name nft -f-
              }''} %I";
            ExecStopPost = "${writeNushellScript "dev-shutdown" ''
                          def main [name: string] {
                          let hosteth = $"veth-host-($name)";
                          ip link del $hosteth
                          $"
                          delete chain ip6 nat tailnet($name)
                          delete chain ip nat tailnet($name)
                          delete chain inet filter tailnet($name)
                          " | nft -f-
                          $"
                          delete chain inet nat tailnet
                          " | ip netns exec $name nft -f-
              }''} %I";
          };
        };
        "tailscaled@" = {
          bindsTo = [ "tailnet-ns@.service" ];
          after = [ "tailnet-dev@.service" ];
          unitConfig.JoinsNamespaceOf = "tailnet-ns@.service";
          path = [
            tailscale
          ];
          serviceConfig = {
            PrivateNetwork = true;
            Type = "notify";
            ExecStart = "${tailscale}/bin/tailscaled -tun tailscale0 --socket /persist/tailnets/%I/tstail.socket --statedir=/persist/tailnets/%I --state /persist/tailnets/%I/tstail.state";
          };
        };
      };
    };

}
