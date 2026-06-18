{ config, ... }: {
  services.xserver.xkb = {
    extraLayouts = import ./keyboard-layouts.nix;
    options = "lv3:ralt_switch";
  };

  system.activationScripts.chromiumXkb = ''
    # deadass no clue what this does, i forgot already
    mkdir -p /usr/share/X11
    ln -sfn ${config.services.xserver.xkb.dir} /usr/share/X11/xkb
  '';

  nixpkgs.overlays = [
    (self: super: {
      sway-unwrapped = super.sway-unwrapped.override {
        libxkbcommon = super.libxkbcommon.override {
          xkeyboard_config = super.xkeyboard-config_custom {
            layouts = config.services.xserver.xkb.extraLayouts;
          };
        };
      };
    })
  ];
}
