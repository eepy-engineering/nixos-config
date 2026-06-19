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
    mysqlDataDir = mkOption { type = types.str; };
    mysqlBackupDir = mkOption { type = types.str; };
    mediawikiDir = mkOption { type = types.str; };
    cloudflaredPem = mkOption { type = types.str; };
    cloudflaredTunnelId = mkOption { type = types.str; };
    cloudflaredTunnel = mkOption { type = types.str; };
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
          reference = "op://Services/${config.smo-wiki.cloudflaredPem}/notesPlain";
        }
        {
          path = "smo-wiki/tunnel.json";
          reference = "op://Services/${config.smo-wiki.cloudflaredTunnel}/notesPlain";
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
          "/mnt/mysql" = {
            hostPath = config.smo-wiki.mysqlDataDir;
            isReadOnly = false;
          };
          "/mnt/backup-mysql" = {
            hostPath = config.smo-wiki.mysqlBackupDir;
            isReadOnly = false;
          };
          "/mnt/mediawiki" = {
            hostPath = config.smo-wiki.mediawikiDir;
            isReadOnly = false;
          };
        };
        specialArgs = {
          inherit (config.smo-wiki) site cloudflaredTunnelId;
        };
        config = {
          imports = [ ./configuration.nix ];
          nixpkgs.pkgs = pkgs;
        };
      };
    };
  };
}
