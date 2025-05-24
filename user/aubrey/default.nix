{
  config,
  pkgs,
  lib,
  opnix,
  isDesktop,
  ...
}: {
  imports = [
    opnix.homeManagerModules.default
  ];

  home = {
    stateVersion = "24.11";

    username = "aubrey";
    homeDirectory = "/home/aubrey";

    packages = with pkgs;
      [
        # development
        neovim # todo: neovim via home manager
      ]
      ++ (
        if isDesktop
        then [
          # development
          gitkraken
          imhex
          unityhub
          unstable.jetbrains.rider
          unstable.jetbrains.clion
          unstable.jetbrains.idea-community
          bruno
          ghidra-bin
          renderdoc
          avalonia-ilspy
          digital
          alejandra

          # art
          pinta
          material-maker
          blender

          # social
          (discord-canary.override {withVencord = true;})
          signal-desktop
          thunderbird

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
  };

  programs = {
    vesktop = {
      enable = true;
      settings = {
        discordBranch = "canary";
        minimizeToTray = true;
        arRPC = true;
        splashTheming = true;
        splashColor = "rgb(219, 220, 223)";
        splashBackground = "rgb(12, 12, 14)";
        spellCheckLanguages = ["en-US" "us"];
        customTitleBar = false;
        enableMenu = false;
        staticTitle = false;
      };

      vencord = {
        settings = builtins.fromJSON (builtins.readFile ./vencord.json);
      };
    };

    vscode = {
      enable = isDesktop;
      package = pkgs.vscodium;
      mutableExtensionsDir = false;

      profiles.default = {
        userSettings = builtins.fromJSON (builtins.readFile ./vscode_settings.json);
        enableUpdateCheck = true;
        enableExtensionUpdateCheck = true;

        extensions = with pkgs.vscode-marketplace; [
          # theming
          trag1c.gleam-theme
          vscode-icons-team.vscode-icons

          # nix
          mkhl.direnv
          kamadorueda.alejandra
          bbenoist.nix

          # dx
          vscodevim.vim

          # languages
          rust-lang.rust-analyzer
          tamasfe.even-better-toml
          thenuprojectcontributors.vscode-nushell-lang
          mkornelsen.vscode-arm64
          ms-vscode.cpptools-extension-pack
          llvm-vs-code-extensions.vscode-clangd
          svelte.svelte-vscode
          ms-vscode.cmake-tools
          visualstudiotoolsforunity.vstuc
          surendrajat.apklab
          loyieking.smalise
          denoland.vscode-deno
          pbkit.vscode-pbkit
          ms-python.python
          haskell.haskell
          justusadam.language-haskell
          ocamllabs.ocaml-platform
        ];
      };
    };

    onepassword-secrets = {
      enable = false;
      tokenFile =
        if isDesktop
        then "/etc/opnix-token"
        else "/var/opnix-token";
      secrets = [
      ];
    };

    ssh = {
      enable = true;
      extraConfig = ''
        Host *
          IdentityAgent ~/.1password/agent.sock
          ForwardAgent yes
        Host sanae6.ca
          User sanae
        Host vm-eepy
          User eepy
        Host vm-pia
          User eepy
      '';
    };

    git = {
      enable = true;
      userName = "Aubrey Taylor";
      userEmail = "aubrey@hall.ly";

      extraConfig = {
        gpg.format = "ssh";
        "gpg \"ssh\"".program = "${lib.getExe' pkgs._1password-gui "op-ssh-signin"}";
        commit.gpgsign = true;
        user.signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJZn43IczAtHI49eULTaA3GY7Zdoy/gqeEIhev/3ub09";
        init.defaultBranch = "main";
        pull.rebase = true;
      };
    };

    nushell = {
      enable = true;
      package = pkgs.nushell;
      configFile.source = ./config.nu;
    };

    carapace = {
      enable = true;
      enableNushellIntegration = true;
    };

    starship = {
      enable = true;
      enableNushellIntegration = true;
    };

    wezterm = {
      enable = isDesktop;
      extraConfig = builtins.readFile ./wezterm.lua;
    };

    swaylock = {
      enable = true;
    };
  };

  services = {
    flameshot = {
      enable = true;
      package =
        (pkgs.flameshot.override {enableWlrSupport = true;}).overrideDerivation
        (oldAttrs: {
          # qtWrapperArgs = ["--set" "QT_QPA_PLATFORM" "xcb"];
        });
      settings = {
        General = {
          contrastOpacity = 188;
          saveAfterCopy = true;
          saveAsFileExtension = "png";
          saveLastRegion = true;
          savePath = "/home/aubrey/Pictures/Screenshots";
          savePathFixed = false;
          showHelp = true;
          showSelectionGeometryHideTime = 3000;
          showSidePanelButton = false;
        };
        Shortcuts = {
          TYPE_COPY = "Ctrl+C";
          TYPE_EXIT = "Ctrl+Q";
        };
      };
    };
  };

  i18n.inputMethod = {
    enable = isDesktop;
    type = "fcitx5";
    fcitx5 = {
      waylandFrontend = true;
      addons = with pkgs; [
        fcitx5-mozc
      ];
    };
  };

  wayland.windowManager.sway = {
    enable = isDesktop;
    extraConfig = with pkgs; ''
      input "type:touchpad" {
        dwt enabled
        tap enabled
        natural_scroll enabled
        middle_emulation enabled
      }

      output eDP-1 pos 0 0 res 2560x1600
      output DP-2 pos 2560 260 res 1920x1080
      output DP-4 pos 4480 260 res 1920x1080

      workspace 1 output eDP-1
      workspace 2 output DP-2
      workspace 3 output DP-4

      set $mod Mod1
      set $term wezterm start --always-new-process

      bindsym Print exec flameshot gui
      bindsym XF86AudioMute exec wpctl set-mute @DEFAULT_SINK@ toggle
      bindsym XF86AudioLowerVolume exec wpctl set-volume @DEFAULT_SINK@ 5%-
      bindsym XF86AudioRaiseVolume exec wpctl set-volume @DEFAULT_SINK@ 5%+
      bindsym XF86AudioPrev playerctl pause
      bindsym XF86AudioPlay playerctl play-pause
      bindsym XF86AudioNext playerctl
      bindsym XF86MonBrightnessDown exec brightnessctl set 5%-
      bindsym XF86MonBrightnessUp exec brightnessctl set 5%+

      #bindsym $mod+Return exec wezterm start --always-new-process

      exec 1password
      exec vesktop
      exec zen
      exec codium

      for_window [app_id="flameshot"] border pixel 0, floating enable, fullscreen disable, move absolute position 0 0

      bindsym Mod4+L exec swayidle \
        timeout 1 'swaylock -i /home/aubrey/Pictures/yuri/wintersunrise.png -f -c 000000; pkill swayidle -n' \
        timeout 10 'swaymsg "output * power off"' resume 'swaymsg "output * power on"' \
        before-sleep 'swaylock -f -c 000000'

      exec swayidle -w \
        timeout 300 'swaylock -i /home/aubrey/Pictures/yuri/wintersunrise.png -f -c 000000; ' \
        timeout 315 'swaymsg "output * power off"' resume 'swaymsg "output * power on"' \
        before-sleep 'swaylock -f -c 000000'
    '';
  };
}
