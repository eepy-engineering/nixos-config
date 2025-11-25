{
  pkgs,
  isDesktop,
  ...
}:
{
  home.packages =
    with pkgs;
    [
      ripgrep
      inetutils
      hactool
    ]
    ++ (
      if isDesktop then
        [
          # development
          gitkraken
          jetbrains.rider
          jetbrains.clion
          jetbrains.idea-community
          bruno
          ghidra-bin
          renderdoc
          avalonia-ilspy
          digital
          nixfmt-tree
          nixfmt-rfc-style
          nixd
          logisim-evolution
          surfer
          swim
          arduino
          arduino-cli
          platformio
          antigravity

          # art
          pinta
          material-maker
          blender
          aseprite

          # social
          (discord-canary.override { withVencord = true; })
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
          anki

          # desktop
          wev
          playerctl
          brightnessctl
          swaylock
          swayidle
        ]
      else
        [ ]
    );
}
