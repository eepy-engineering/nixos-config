{ pkgs, ... }:
{
  programs.nushell.extraEnv = ''
    def ghidra [] {
      _JAVA_AWT_WM_NONREPARENTING=1 ${pkgs.stable-pkgs.ghidra}/lib/ghidra/ghidraRun
    }
  '';
}
