{ pkgs, ... }:
{
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
    flatpak.enable = true;
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
      extraPortals = with pkgs; [
        (xdg-desktop-portal-wlr.overrideAttrs (orig: {
          src = fetchFromGitHub {
            owner = "David96";
            repo = "xdg-desktop-portal-wlr";
            rev = "1e397357d451b637f0dc897b12be1e8153d4860f";
            sha256 = "sha256-wWcAJ2V/u/Suw9zSOBLLuPckmYaRTTxrfsjB0UPpeMA=";
          };
          buildInputs = orig.buildInputs ++ [ libxkbcommon ];
        }))
        xdg-desktop-portal-gtk
      ];
    };
  };

  services.xserver.xkb.extraLayouts = {
    tetra-us = {
      description = "tetra's awesome layout (us)";
      languages = [ "custom" ];
      symbolsFile = ./tetra-layout-us;
    };
  };

  environment.sessionVariables = {
    "NIXOS_OZONE_WL" = "1";
  };
}
