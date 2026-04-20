{ pkgs, ... }:
{
  networking = {
    hostName = "puppygirl";
    nameservers = [
      "1.1.1.1"
      "1.0.0.1"
      "2606:4700:4700::1111"
      "2606:4700:4700::1001"
    ];
    hosts = {
      "100.70.181.9" = [ "kokuzo" ];
    };
    useNetworkd = true;
    networkmanager.wifi.powersave = false;
  };

  systemd.network.wait-online.enable = false;

  services.resolved = {
    enable = true;
    settings = {
      Resolve = {
        DNSSEC = "true";
        Domains = [ "~." ];
        FallbackDNS = [
          "1.1.1.1"
          "1.0.0.1"
          "2606:4700:4700::1111"
          "2606:4700:4700::1001"
        ];
        DNSOverTLS = "true";
      };
    };
  };

  services.tailscale = {
    enable = true;
  };

  opnix = {
    secrets = [
      {
        path = "ny.ovpn";
        reference = "op://Services/TP-Link VPN Config/notesPlain";
      }
    ];
    services = [ "openvpn-ny.service" ];
    # users = [ config.users.users.systemd-network.name ];
  };
  services.openvpn.servers.ny.config = "config ${pkgs.asOpnixPath "ny.ovpn"}";

  # services.pia-vpn = {
  #   # region = "ca_toronto";
  # };

  imports = [
    ./multi-tailnet.nix
    # ../components/pia
  ];

  services.multi-tailnet = {
    enable = true;
    tailnets = {
      roob = {
        authKeyFile = "/etc/roob.tskey";
        ipv4Address = "192.168.101.1";
        ipv4AddressSub = "192.168.101.2";
        ipv4AddressDns = "192.168.101.53";
      };
    };
  };
}
