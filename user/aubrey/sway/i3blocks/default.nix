{
  pkgs,
  config,
  ...
}:
{
  imports = [
    ./module.nix
  ];

  i3blocks = {
    global = {
      command = "${pkgs.nushell}/bin/nu ${./.}/$BLOCK_NAME.nu";
      separator = true;
      separator_block_width = 15;
      markup = "pango";
    };

    blocks = [
      {
        name = "time";
        interval = 1;
        json = true;
        vars = {
          current_tz = "0";
          mode = "true";
        };
      }
      {
        name = "battery";
        interval = 20;
      }
      {
        name = "volume";
        interval = 1;
        json = true;
      }
      {
        name = "storage";
        interval = 60;
      }
      {
        name = "wifi";
        interval = 3;
        signal = 1;
        json = true;
      }
    ];
  };

  home.packages = [
    pkgs.i3blocks
  ];

  wayland.windowManager.sway.config = {
    bars = [
      {
        fonts = {
          names = [ "pango:monospace" ];
          size = 14.5;
        };
        statusCommand = "i3blocks -c ${config.xdg.configHome}/i3blocks/config";
      }
    ];
  };
}
