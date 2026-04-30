{ isDesktop, ... }:
{
  fonts.fontconfig = {
    enable = isDesktop;
    defaultFonts = {
      monospace = [
        "Comic Mono"
        "nasin-nanpa"
      ];
    };
  };
}
