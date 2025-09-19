{ isDesktop, ... }:
{
  fonts.fontconfig = {
    enable = isDesktop;
    defaultFonts = {
      monospace = [
        "Comic Mono"
        "Jetbrains Mono"
      ];
    };
  };
}
