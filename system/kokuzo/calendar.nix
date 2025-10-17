{ pkgs, ... }:
{
  opnix = {
    secrets = [
      {
        path = "radicale/htpasswd";
        reference = "op://Services/Radicale - htpasswd/notesPlain";
      }
    ];
    services = [ "radicale.service" ];
    users = [ "radicale" ];
  };

  services.radicale = {
    enable = true;

    settings = {
      server = {
        hosts = [
          "0.0.0.0:5232"
          "[::]:5232"
        ];
      };
      rights = {
        type = "authenticated";
      };
      auth = {
        type = "htpasswd";
        htpasswd_filename = pkgs.asOpnixPath "radicale/htpasswd";
        htpasswd_encryption = "bcrypt";
      };
      storage = {
        filesystem_folder = "/mnt/tank/radicale";
      };
    };
  };
}
