{ pkgs, ... }: {
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
}
