{
  config,
  pkgs,
  isDesktop,
  ...
}: {
  wayland.windowManager.hyprland = {
    #enable = isDesktop;
    enable = true;
    package = pkgs.hyprland;
    xwayland.enable = true;
    systemd.enable = true;

    settings = {
      decoration = {
        shadow_offset = "0 5";
        "col.shadow" = "rgba(00000099)";
      };

      "$mod" = "SUPER";

      bind = [
        "$mod, D"
      ];
    };
  };
}
