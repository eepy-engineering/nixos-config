{pkgs, ...}: {
  networking.hostName = "aubrey-laptop-nixos";
  networking.nameservers = [
    "1.1.1.1"
    "1.0.0.1"
  ];
  services.resolved = {
    enable = true;
    dnssec = "true";
    domains = ["~."];
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
    services = ["openvpn-ny.service"];
  };
  services.openvpn.servers.ny.config = "config ${pkgs.asOpnixPath "ny.ovpn"}";
}
