{
  pkgs,
  isDesktop,
  ...
}: {
  home.
    packages = with pkgs;
    [
      ripgrep
    ]
    ++ (
      if isDesktop
      then [
        # development
        gitkraken
        imhex
        jetbrains.rider
        jetbrains.clion
        jetbrains.idea-community
        bruno
        ghidra-bin
        renderdoc
        avalonia-ilspy
        digital
        alejandra
        nixd
        logisim-evolution
        surfer-unstable
        gtkwave
        swim-unstable

        # art
        pinta
        material-maker
        blender

        # social
        (discord-canary.override {withVencord = true;})
        signal-desktop
        thunderbird
        bluebubbles

        # web
        zen-browser
        chromium

        # games
        prismlauncher
        ryujinx

        # tools
        wl-clipboard
        kdePackages.plasma-systemmonitor
        kdePackages.kcalc
        obsidian
        rustdesk

        # desktop
        wev
        playerctl
      ]
      else []
    );
}
