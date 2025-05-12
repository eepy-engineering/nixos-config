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
    opnix = {
      secrets = [
        {
          path = "samba/username";
          reference = config.tank-mount.opnix-login-references.username;
        }
        {
          path = "samba/password";
          reference = config.tank-mount.opnix-login-references.password;
        }
      ];

      services = ["samba-credentials.service"];
    };

    systemd.services.samba-credentials = {
      description = "Prepare secrets from 1Password Service Vault";
      serviceConfig = {
        Type = "oneshot";
      };
      script = ''
        ${pkgs.nushell}/bin/nu ${builtins.toFile "build-samba-creds.nu" ''
          let username = open ${pkgs.asOpnixPath "samba/username"};
          let password = open ${pkgs.asOpnixPath "samba/password"};
          $"username=($username)\npassword=($password)" | save -f ${pkgs.asOpnixPath "samba/credentials"}
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
            requires = "samba-credentials.service";
          };
          vers = "3.1.1";
          noauto = true;
          posix = true;

          credentials = pkgs.asOpnixPath "samba/credentials";
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
