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
      python3
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
          master-pkgs.godot-mono
          spade
          swim

          # art
          krita
          material-maker
          blender
          lmms-full

          # school
          lorien
          texliveFull
          texstudio
          graphviz
          libreoffice-qt
          typst
          typstyle

          # social
          (discord-canary.override { withVencord = true; })
          signal-desktop
          thunderbird
          zulip
          bluebubbles

          # web
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
          vlc

          # games
          prismlauncher
          ryubing
          osu-lazer-bin
          everest-mons
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
          kdePackages.kdeconnect-kde
          pciutils
          perf
          v4l-utils
          pkgs.android-tools
          dive
          gdb
          lldb
          llvmPackages.bintools-unwrapped
          remmina
          qpwgraph
          _010editor
          libfaketime

          # desktop
          wev
          xev
          playerctl
          brightnessctl
          swaylock
          swayidle
          mako
        ]
      else
        [ ]
    );
}
