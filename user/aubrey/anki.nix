{ pkgs, ... }:
{
  home.packages = with pkgs; [
    anki-bin
  ];

  programs.nushell.extraEnv = ''
    $env.ANKI_WAYLAND = 1;
  '';
}
