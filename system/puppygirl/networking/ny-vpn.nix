{ pkgs, ... }: {
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
}
