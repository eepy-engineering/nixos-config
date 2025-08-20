{isDesktop, ...}: {
  programs.wezterm = {
    enable = isDesktop;
    extraConfig = builtins.readFile ./wezterm.lua;
  };
}
