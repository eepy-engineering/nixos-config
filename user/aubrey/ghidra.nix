{ pkgs, ... }:
{
  programs.nushell.extraEnv = ''
    def ghidra [] {
      _JAVA_AWT_WM_NONREPARENTING=1 ${pkgs.ghidra}/lib/ghidra/ghidraRun
    }
  '';
}
