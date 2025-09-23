{ pkgs, ... }:
{
  systemd.services = {
    "netns@" = {
      description = "%i network namespace";
      serviceConfig = with pkgs; {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = "${iproute}/bin/ip netns add %i";
        ExecStop = "${iproute}/bin/ip netns del %i";
      };
    };

    "lo@" = {
      description = "loopback in %i network namespace";

      bindsTo = [ "netns@.service" ];
      after = [ "netns@.service" ];

      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart =
          let
            start =
              with pkgs;
              writeShellScript "lo-up" ''
                set -e

                ${iproute}/bin/ip -n $1 addr add 127.0.0.1/8 dev lo
                ${iproute}/bin/ip -n $1 link set lo up
              '';
          in
          "${start} %i";
        ExecStopPost = with pkgs; "${iproute}/bin/ip -n %i link del lo";
      };
    };

    # This unit assumes a file named /etc/netns-<network namespace>-veth-ips
    # exists to set IPV4_HOST and IPV4_NS environment variables to valid
    # IPv4 addresses to be used for the two sides of the veth interface.
    "veth@" = {
      description = "virtual ethernet network interface between the main and %i network namespaces";

      bindsTo = [ "netns@.service" ];
      after = [ "netns@.service" ];

      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart =
          let
            start =
              with pkgs;
              writeShellScript "veth-up" ''
                set -e

                . /etc/netns-$1-veth-ips

                # As this templated unit potentially has multiple units running
                # simultaneously, the interface is created with a unique name in
                # the main network namespace, then moved to the new network
                # namespace and renamed.
                ${iproute}/bin/ip link add ve-$1 type veth peer name eth-lan-$1
                ${iproute}/bin/ip link set eth-lan-$1 netns $1
                ${iproute}/bin/ip -n $1 link set dev eth-lan-$1 name eth-lan
                ${iproute}/bin/ip addr add $IPV4_HOST/32 dev ve-$1
                ${iproute}/bin/ip -n $1 addr add $IPV4_NS/32 dev eth-lan
                ${iproute}/bin/ip link set ve-$1 up
                ${iproute}/bin/ip -n $1 link set eth-lan up
                ${iproute}/bin/ip route add $IPV4_NS/32 dev ve-$1
                ${iproute}/bin/ip -n $1 route add $IPV4_HOST/32 dev eth-lan
              '';
          in
          "${start} %i";
        ExecStopPost =
          let
            stop =
              with pkgs;
              writeShellScript "veth-down" ''
                ${iproute}/bin/ip -n $1 link del eth-lan
                ${iproute}/bin/ip link del ve-$1
              '';
          in
          "${stop} %i";
      };
    };

    # This unit assumes a Wireguard configuration file exists at
    # /etc/wg-<network namespace>.conf. Note this is a Wireguard configuration
    # file, not a wg-quick configuration file. See "CONFIGURATION FILE FORMAT
    # EXAMPLE" in wg(8).
    #
    # This further assumes a file exists at /etc/netns-<network
    # namespace>-wg-ips to set IPV4 and IPV6 environment variables to valid IP
    # addresses to be used by the Wireguard interface.
    "wg@" = {
      description = "wg network interface in %i network namespace";

      bindsTo = [ "netns@.service" ];
      wants = [
        "network-online.target"
        "nss-lookup.target"
      ];
      after = [
        "netns@.service"
        "network-online.target"
        "nss-lookup.target"
      ];

      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        Restart = "on-failure";
        RestartSec = 3;
        ExecStart =
          let
            start =
              with pkgs;
              writeShellScript "wg-up" ''
                set -e

                . /etc/netns-$1-wg-ips

                # As this templated unit potentially has multiple units running
                # simultaneously, the interface is created with a unique name in
                # the main network namespace, then moved to the new network
                # namespace and renamed.
                ${iproute}/bin/ip link add wg-$1 type wireguard
                ${iproute}/bin/ip link set wg-$1 netns $1
                ${iproute}/bin/ip -n $1 link set dev wg-$1 name wg0
                ${iproute}/bin/ip -n $1 addr add $IPV4 dev wg0
                ${iproute}/bin/ip -n $1 -6 addr add $IPV6 dev wg0
                ${iproute}/bin/ip netns exec $1 \
                  ${wireguard-tools}/bin/wg setconf wg0 /etc/wg-$1.conf
                ${iproute}/bin/ip -n $1 link set wg0 up
                ${iproute}/bin/ip -n $1 route add default dev wg0
                ${iproute}/bin/ip -n $1 -6 route add default dev wg0
              '';
          in
          "${start} %i";
        ExecStopPost =
          let
            stop =
              with pkgs;
              writeShellScript "wg-down" ''
                ${iproute}/bin/ip -n $1 route del default dev wg0
                ${iproute}/bin/ip -n $1 -6 route del default dev wg0
                ${iproute}/bin/ip -n $1 link del wg0
              '';
          in
          "${stop} %i";
      };
    };
  };
}
