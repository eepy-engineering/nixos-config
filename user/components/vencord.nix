{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.programs.vesktop;
in {
  meta.maintainers = [
    {
      name = "Rose Kodsi-Hall";
      email = "rose@hall.ly";
      github = "roobscoob";
      githubId = 7334383;
    }
  ];

  options = {
    programs.vesktop = {
      enable = lib.mkEnableOption "Vesktop is a custom Discord App aiming to give you better performance and improve linux support";

      package = lib.mkPackageOption pkgs "vesktop" {nullable = true;};

      vesktopSettings = mkOption {
        type = pkgs.formats.json.type;
        default = {};
        description = ''
          Settings to be written to the Vencord configuration file.
        '';
      };

      vencordSettings = mkOption {
        type = pkgs.formats.json.type;
        default = {};
        description = ''
          Settings to be written to the Vencord configuration file.
        '';
      };

      quickCss = mkOption {
        type = lib.types.str;
        default = "";
        description = ''
          The custom QuickCSS to use.
        '';
      };

      themes = mkOption {
        type = lib.types.attrsOf lib.types.str;
        default = {};
        description = ''
          Additional themes to load.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = lib.mkIf (cfg.package != null) [cfg.package];

    xdg.configFile."vesktop/settings.json".text = builtins.toJSON;
  };
}
