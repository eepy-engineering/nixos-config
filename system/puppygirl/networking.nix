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
      dovecote = [ "100.123.120.127" ];
      catbox = [ "100.77.206.54" ];
    };
    useNetworkd = true;
  };

  systemd.network.wait-online.enable = false;

  services.resolved = {
    enable = true;
    dnssec = "true";
    domains = [ "~." ];
    fallbackDns = [
      "1.1.1.1"
      "1.0.0.1"
      "2606:4700:4700::1111"
      "2606:4700:4700::1001"
    ];
    dnsovertls = "true";
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

  services.pia-vpn = {
    region = "ca_toronto";
  };

  imports = [
    ./multi-tailnet.nix
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
