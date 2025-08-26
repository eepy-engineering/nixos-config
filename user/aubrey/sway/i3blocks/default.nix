{
  pkgs,
  lib,
  config,
  ...
}: {
  # i3blocks hm module doesn't root keys
  xdg.configFile."i3blocks/bottom".text = let
    wrapNushell = filename: "${pkgs.writeNushellScript "${filename}.nu" (builtins.readFile (./. + "/${filename}.nu"))}";
    global = {
      command = "${./.}/$BLOCK_NAME.nu";
      separator = true;
      separator_block_width = 15;
      markup = "pango";
    };
    bars = {
      time = {
        interval = 1;
        format = "json";
        current_tz = 1;
      };
      volume = {
        interval = 1;
        format = "json";
      };
      storage = {
        interval = 30;
      };
    };
  in
    (lib.generators.toKeyValue {} global)
    + "\n"
    + ((lib.generators.toINI {}) (builtins.mapAttrs (name: value: value // {command = wrapNushell name;}) bars));

  home.packages = [
    pkgs.i3blocks
  ];

  wayland.windowManager.sway.config = {
    bars = [
      {
        fonts = {
          names = ["pango:monospace"];
          size = 14.5;
        };
        statusCommand = "i3blocks -c ${config.xdg.configHome}/i3blocks/bottom";
      }
    ];
  };
}
