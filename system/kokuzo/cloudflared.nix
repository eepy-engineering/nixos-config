{pkgs, ...}: {
  opnix = {
    secrets = [
      {
        path = "cloudflared.pem";
        reference = "op://Services/r2k6rwy6oxeiswivakiorwfhwy/notesPlain";
      }
      {
        path = "tunnel.json";
        reference = "op://Services/dd5hu33p5yx34qxgxbayqpjyza/notesPlain";
      }
    ];
    services = ["cloudflared-tunnel-9407ea8e-0f2c-45d0-9265-9797d2bbe5d1.service"];
  };
  services.cloudflared = {
    enable = true;
    certificateFile = pkgs.asOpnixPath "cloudflared.pem";
    tunnels = {
      "9407ea8e-0f2c-45d0-9265-9797d2bbe5d1" = {
        credentialsFile = pkgs.asOpnixPath "tunnel.json";
        default = "status:404";
      };
    };
  };
}
