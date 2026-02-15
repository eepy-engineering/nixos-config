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
          jetbrains.idea
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
          nautilus
          bluetui
          croc
          electrum

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
