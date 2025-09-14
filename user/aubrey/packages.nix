{
  pkgs,
  isDesktop,
  ...
}: {
  home.packages = with pkgs;
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
        arduino
        arduino-cli

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
        transmission_4-qt6

        # music
        strawberry
        nicotine-plus
        pavucontrol

        # games
        prismlauncher
        ryubing

        # tools
        wl-clipboard
        kdePackages.kcalc
        obsidian
        filezilla
        fontpreview
        acpi

        # desktop
        wev
        playerctl
        brightnessctl
      ]
      else []
    );
}
