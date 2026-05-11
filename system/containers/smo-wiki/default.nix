{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.smo-wiki = with lib; {
    enable = mkEnableOption "smo wiki";
    site = mkOption { type = types.str; };
    mysqlDataDir = mkOption { type = types.nullOr types.str; };
    mysqlBackupDir = mkOption { type = types.nullOr types.str; };
  };
  config = lib.mkIf config.smo-wiki.enable {
    opnix = {
      secrets = [
        {
          path = "smo-wiki/webhook";
          reference = "op://Services/SMO.wiki Discord Webhook/password";
        }
        {
          path = "smo-wiki/admin-password";
          reference = "op://Services/SMO.wiki admin/password";
        }
        {
          path = "smo-wiki/cloudflared.pem";
          reference = "op://Services/h3ewjwxbus3gops6qi4naiwpn4/notesPlain";
        }
        {
          path = "smo-wiki/tunnel.json";
          reference = "op://Services/ty24aofrqct3solie6v2iv7fke/notesPlain";
        }
        {
          path = "smo-wiki/secure-settings.php";
          reference = "op://Services/ppc2qqkl6mdtxmgjtestpmjkhi/notesPlain";
        }
      ];
      services = [ "container@smo-wiki.service" ];
    };

    containers = {
      smo-wiki = {
        autoStart = true;
        privateNetwork = false;
        bindMounts = {
          "/mnt/opnix/smo-wiki" = {
            hostPath = pkgs.asOpnixPath "smo-wiki";
            isReadOnly = true;
          };
          "/mnt/mysql" = lib.mkIf (config.smo-wiki.mysqlDataDir != null) {
            hostPath = config.smo-wiki.mysqlDataDir;
            isReadOnly = false;
          };
          "/mnt/backup-mysql" = lib.mkIf (config.smo-wiki.mysqlBackupDir != null) {
            hostPath = config.smo-wiki.mysqlBackupDir;
            isReadOnly = false;
          };
        };
        specialArgs = {
          inherit (config.smo-wiki) site;
          shouldBackup = config.smo-wiki.mysqlBackupDir != null;
        };
        config = {
          imports = [ ./configuration.nix ];
          nixpkgs.pkgs = pkgs;
        };
      };
    };
  };
}
