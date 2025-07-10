{
  config,
  pkgs,
  lib,
  opnix,
  inputs,
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
        nix-index
      ]
      ++ (
        if isDesktop
        then [
          # development
          gitkraken
          imhex
          # unityhub
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

  nix.settings = {
    experimental-features = "nix-command flakes local-overlay-store";
    accept-flake-config = true;
    warn-dirty = false;
  };

  programs = {
    vesktop = {
      enable = isDesktop;
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
          tauri-apps.tauri-vscode

          # languages
          rust-lang.rust-analyzer
          tamasfe.even-better-toml
          thenuprojectcontributors.vscode-nushell-lang
          mkornelsen.vscode-arm64
          ms-vscode.cpptools-extension-pack
          llvm-vs-code-extensions.vscode-clangd
          svelte.svelte-vscode
          ms-vscode.cmake-tools
          surendrajat.apklab
          loyieking.smalise
          denoland.vscode-deno
          pbkit.vscode-pbkit
          ms-python.python
          haskell.haskell
          justusadam.language-haskell
          ocamllabs.ocaml-platform
          bradlc.vscode-tailwindcss
        ];
      };
    };

    zed-editor = {
      enable = isDesktop;
      extensions = [
        "lua"
        "nix"
        "nushell"
        "vscode-dark-plus"
        "wgsl"
      ];
      userSettings = {
        features = {
          copilot = false;
        };
        telemetry.metrics = false;
        vim_mode = true;
        load_direnv = "shell_hook";
        buffer_font_family = "Comic Mono";
        buffer_font_fallbacks = ["Zed Plus Mono"];
        autosave.after_delay.milliseconds = 300;
        relative_line_numbers = true;
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
      forwardAgent = true;
      extraConfig = ''
        Host *
          IdentityAgent ~/.1password/agent.sock
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
      extraConfig = let
        nu-scripts = inputs.nu-scripts;
      in ''
        $env.config.hooks.command_not_found = source ${pkgs.nix-index}/etc/profile.d/command-not-found.nu
      '';
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
      enable = isDesktop;
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

  # services = {
  #   mako = {
  #     enable = isDesktop;
  #   };
  # };

  wayland.windowManager.sway = with pkgs; {
    enable = isDesktop;
    config = let
    in {
      assigns = {
        "1" = [{class = "vesktop";}];
        "2" = [{class = "VSCodium";} {app_id = "org.wezfurlong.wezterm";}];
        "3" = [{class = "1Password";} {app_id = "zen";}];
      };

      input = {
        "type:touchpad" = {
          dwt = "enabled";
          tap = "enabled";
          natural_scroll = "enabled";
          middle_emulation = "enabled";
        };
      };

      keybindings = let
        modifier = config.wayland.windowManager.sway.config.modifier;
      in
        lib.mkOptionDefault {
          XF86AudioMute = "exec wpctl set-mute @DEFAULT_SINK@ toggle";
          XF86AudioLowerVolume = "exec wpctl set-volume @DEFAULT_SINK@ 5%-";
          XF86AudioRaiseVolume = "exec wpctl set-volume @DEFAULT_SINK@ 5%+";
          XF86AudioPrev = "exec playerctl previous";
          XF86AudioPlay = "exec playerctl play-pause";
          XF86AudioNext = "exec playerctl next";
          XF86MonBrightnessDown = "exec brightnessctl set 5%-";
          XF86MonBrightnessUp = "exec brightnessctl set 5%+";

          "Mod4+L" = "exec ${writeNushellScript "sleep" ''
            swaymsg "exec swayidle timeout 2 'swaymsg \"output * power off\"' resume 'swaymsg \"output * power on\"'"

            swaylock -i /home/aubrey/Pictures/yuri/wintersunrise.png -c 000000
            pkill -n swayidle

            # safety call in case resume didn't finish executing
            swaymsg "output * power on"
          ''}";
          Print = "exec ${writeNushellScript "flameshot-screenie" ''
            let success = (${flameshot}/bin/flameshot gui -p ~/Pictures/Screenshots/ | complete | get exit_code) == 0;

            if $success {
              ls ~/Pictures/Screenshots/ | sort-by modified | last | get name | open | ${wl-clipboard}/bin/wl-copy
            }
          ''}";
        };

      output = {
        eDP-1 = {
          pos = "0 0";
          res = "2560x1600";
        };
        DP-2 = {
          pos = "2560 260";
          res = "1920x1080";
        };
        DP-4 = {
          pos = "4480 260";
          res = "1920x1080";
        };
      };

      startup = [
        {command = "${zen-browser}/bin/zen";}
        {command = "${wezterm}/bin/wezterm";}
        {command = "${_1password-gui}/bin/1password";}
        {command = "${vscodium}/bin/codium";}
        {command = "${vesktop}/bin/vesktop";}
        {
          command = lib.concatStringsSep " " [
            "swayidle -w"
            "timeout 300 'swaylock -i /home/aubrey/Pictures/yuri/wintersunrise.png -f -c 000000; '"
            "timeout 315 'swaymsg \"output * power off\"'"
            "resume 'swaymsg \"output * power on\"'"
            "before-sleep 'swaylock -f -c 000000'"
          ];
        }
      ];

      terminal = "${wezterm}/bin/wezterm start --always-new-process";

      window.commands = [
        {
          command = "border pixel 0, floating enable, fullscreen disable, move absolute position 0 0";
          criteria = {app_id = "flameshot";};
        }
      ];

      workspaceLayout = "tabbed";
      workspaceOutputAssign = [
        {
          output = "eDP-1";
          workspace = "1";
        }
        {
          output = "DP-2";
          workspace = "2";
        }
        {
          output = "DP-4";
          workspace = "3";
        }
      ];
    };
  };
}
