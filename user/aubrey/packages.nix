{
  pkgs,
  isDesktop,
  ...
}: {
  home.
    packages = with pkgs;
    [
      ripgrep
      inetutils
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
        ryubing

        # tools
        wl-clipboard
        kdePackages.plasma-systemmonitor
        kdePackages.kcalc
        obsidian
        rustdesk
        filezilla
        fontpreview

        # desktop
        wev
        playerctl
        brightnessctl
      ]
      else []
    );
}
