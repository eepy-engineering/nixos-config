{ isDesktop, pkgs, ... }:
{
  programs.rio = {
    enable = isDesktop;
    settings = {
      developer = {
        log_level = "trace";
        enable-log-file = true;
      };
      fonts = {
        size = 15;
        additional-dirs = [
          "${pkgs.nasin-nanpa-ucsur}/share/fonts/opentype"
        ];
        regular = {
          family = "Comic Mono";
        };
        symbol-map = [
          {
            start = "F1900";
            end = "F19FF";
            font-family = "nasin-nanpa";
          }
        ];
        extras = [
          {
            family = "nasin-nanpa";
          }
          { family = "Klee One"; }
        ];
      };
    };
  };
}
