{ pkgs, ... }:
{
  home.packages = with pkgs; if isDesktop then [
    anki-bin
  ]else [];

  programs.nushell.extraEnv = ''
    $env.ANKI_WAYLAND = 1;
  '';
}
