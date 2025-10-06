{ pkgs, ... }:
{
  opnix = {
    secrets = [
      {
        path = "stalwart/users/aubrey";
        reference = "op://Services/Stalwart - Aubrey/password";
      }
      {
        path = "stalwart/users/tetra";
        reference = "op://Services/Stalwart - Tetra/password";
      }
    ];
    services = [ "stalwart-mail.service" ];
  };
  services.stalwart-mail = {
    enable = true;

    settings = {
      server = {
        hostname = "kokuzo";
        tls.enable = false;
        listener = {
          jmap = {
            bind = "[::]:8484";
            url = "https://cal.hall.ly";
            protocol = "jmap";
          };
          management = {
            bind = [ "0.0.0.0:8484" ];
            protocol = "http";
          };
        };
      };

      store."rocky" = {
        type = "rocksdb";
        path = "/mnt/tank/stalwart";
        min-blob-size = "16834";
        write-buffer-size = "134217728";
      };
      session.auth = {
        mechanisms = "[plain, auth]";
        directory = "'active'";
      };
      storage.directory = "active";
      session.rcpt.directory = "'active'";
      directory."active" = {
        type = "internal";
        store = "rocky";
        principals = [
          {
            class = "individual";
            name = "Aubrey";
            # secret = "%{file:${pkgs.asOpnixPath "stalwart/users/aubrey"}}%";
            secret = "foobar";
            email = [ "aubrey@hall.ly" ];
            roles = [
              "user"
              "admin"
            ];
          }
          {
            class = "individual";
            name = "Tetra";
            secret = "%{file:${pkgs.asOpnixPath "stalwart/users/tetra"}}%";
            email = [ "tetra@proton.me" ];
          }
        ];
      };
      authentication.fallback-admin = {
        user = "aubrey";
        secret = "foobar";
      };
    };
  };
}
