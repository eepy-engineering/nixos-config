{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    tank-mount = {
      enable = lib.mkEnableOption "tank mount";
      username = lib.mkOption {
        type = lib.types.str;
        description = "The username of the user that will own the files";
      };
      opnix-login-references = {
        username = lib.mkOption {
          type = lib.types.str;
          description = "Secret reference for samba username";
        };
        password = lib.mkOption {
          type = lib.types.str;
          description = "Secret reference for samba password";
        };
      };
    };
  };

  config = {
    opnix.secrets = [
      {
        path = "samba/username";
        reference = config.tank-mount.opnix-login-references.username;
      }
      {
        path = "samba/password";
        reference = config.tank-mount.opnix-login-references.password;
      }
    ];

    system.activationScripts.samba-credentials = {
      deps = ["onepassword-secrets"];
      text = ''
        ${pkgs.nushell}/bin/nu ${builtins.toFile "build-samba-creds.nu" ''
          let username = open /var/lib/opnix/secrets/samba/username;
          let password = open /var/lib/opnix/secrets/samba/password;
          $"username=($username)\npassword=($password)" | save -f /var/lib/opnix/secrets/samba/credentials
        ''}
      '';
    };

    fileSystems."/mnt/tank" = {
      device = "//kokuzo.tailc38f.ts.net/tank";
      fsType = "cifs";
      depends = ["/"];
      options = [
        (import ../../util/cifs-options.nix lib {
          x-systemd = {
            automount = true;
            idle-timeout = 60;
            device-timeout = "5s";
            mount-timeout = "5s";
          };
          vers = "3.1.1";
          noauto = true;
          posix = true;

          credentials = "/var/lib/opnix/secrets/samba/credentials";
        })
      ];
    };

    security.wrappers."mount.cifs" = {
      program = "mount.cifs";
      source = "${lib.getBin pkgs.cifs-utils}/bin/mount.cifs";
      owner = "root";
      group = "root";
      setuid = true;
    };
  };
}
