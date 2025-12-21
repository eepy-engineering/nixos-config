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
      zulip-term
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
          bun
          zellij

          # art
          pinta
          material-maker
          blender
          aseprite

          # social
          (discord-canary.override { withVencord = true; })
          signal-desktop
          thunderbird
          zulip
          bluebubbles

          # web
          zen-browser
          chromium
          transmission_4-qt6

          # music
          strawberry
          nicotine-plus
          pavucontrol
          puddletag

          # games
          prismlauncher
          ryubing
          wineWowPackages.unstableFull

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
