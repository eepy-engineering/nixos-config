{ pkgs, ... }:
{
  #services.displayManager.sddm = {
  #  enable = false;
  #  wayland = {
  #    enable = true;
  #  };
  #};
  environment.systemPackages = [
    pkgs.sway
  ];

  programs.hyprland.enable = true;

  security.polkit.enable = true;
  security.pam.services.swaylock = { };

  services = {
    greetd = {
      enable = true;
      useTextGreeter = true;
      settings = {
        default_session = {
          command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd sway";
          user = "greeter";
        };
      };
    };
    printing.enable = true;
    pipewire = {
      enable = true;
      pulse.enable = true;
    };
    libinput.enable = true;
  };

  xdg = {
    mime.enable = true;
    portal = {
      config = {
        common = {
          default = [
            "wlr"
          ];
        };
      };

      enable = true;
      wlr.enable = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-gtk
      ];
    };
  };
}
