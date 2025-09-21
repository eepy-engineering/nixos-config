{ pkgs, ... }:
{
  networking = {
    hostName = "puppygirl";
    nameservers = [
      "1.1.1.1"
      "1.0.0.1"
    ];
    hosts = {
      dovecote = [ "100.123.120.127" ];
      catbox = [ "100.77.206.54" ];
    };
  };
  services.resolved = {
    enable = true;
    dnssec = "true";
    domains = [ "~." ];
    fallbackDns = [
      "1.1.1.1"
      "1.0.0.1"
    ];
    dnsovertls = "true";
  };

  opnix = {
    secrets = [
      {
        path = "ny.ovpn";
        reference = "op://Services/TP-Link VPN Config/notesPlain";
      }
    ];
    services = [ "openvpn-ny.service" ];
  };
  services.openvpn.servers.ny.config = "config ${pkgs.asOpnixPath "ny.ovpn"}";

  services.pia-vpn = {
    region = "ca_toronto";
  };
}
