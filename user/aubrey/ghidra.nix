{ pkgs, ... }:
{
  programs.nushell.extraEnv = ''
    $env._JAVA_AWT_WM_NONREPARENTING = "1"
  '';

  home.packages = [
    pkgs.ghidra
  ];
}
