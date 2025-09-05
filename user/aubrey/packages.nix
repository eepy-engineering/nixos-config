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
      hactool
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
        surfer
        swim

        # art
        pinta
        material-maker
        blender
        aseprite

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
