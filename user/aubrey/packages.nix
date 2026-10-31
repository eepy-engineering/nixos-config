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
      waypipe
      (python3.withPackages (
        ps: with ps; [
          binsync
          pyghidra
        ]
      ))
    ]
    ++ (
      if isDesktop then
        [
          # development
          gitkraken
          jetbrains.rider
          # jetbrains.clion
          intellij-idea
          # jetbrains.rust-rover
          android-studio
          bruno
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
          godot-mono
          spade
          swim
          switch-toolbox
          jdk25
          scrcpy

          # reading
          foliate

          # art
          krita
          material-maker
          blender
          lmms-full
          pinta

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
          thunderbird
          zulip

          # web
          chromium

          # media
          strawberry
          nicotine-plus
          pavucontrol
          puddletag
          syncplay
          mpv
          transmission_4-qt
          vlc
          cmus
          cmusfm
          jellyfin-desktop

          # games
          prismlauncher
          ryubing
          osu-lazer-bin
          everest-mons
          archipelago
          # wineWowPackages.unstableFull

          # tools
          wl-clipboard
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
          imhex
          xxd

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
