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
      waypipe
    ]
    ++ (
      if isDesktop then
        [
          # development
          gitkraken
          jetbrains.rider
          jetbrains.clion
          jetbrains.idea-oss
          jetbrains.rust-rover
          android-studio
          bruno
          ghidra-bin
          renderdoc
          avalonia-ilspy
          digital
          nixfmt-tree
          nixd
          logisim-evolution
          surfer
          swim
          arduino
          arduino-cli
          platformio
          bun
          zellij
          gamemakerEnv
          wgsl-analyzer
          antigravity
          master-pkgs.godot-mono
          python3

          # art
          pinta
          material-maker
          blender

          # social
          (discord-canary.override { withVencord = true; })
          signal-desktop
          thunderbird
          zulip
          bluebubbles

          # web
          zen-browser
          chromium
          floorp-bin

          # media
          strawberry
          nicotine-plus
          pavucontrol
          puddletag
          syncplay
          mpv
          transmission_4-qt6

          # games
          prismlauncher
          ryubing
          # wineWowPackages.unstableFull

          # tools
          wl-clipboard
          kdePackages.kcalc
          obsidian
          filezilla
          fontpreview
          acpi
          nautilus
          bluetui
          croc
          jq
          kdePackages.qttools

          # desktop
          wev
          xev
          playerctl
          brightnessctl
          swaylock
          swayidle
        ]
      else
        [ ]
    );
}
