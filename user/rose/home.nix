{
  config,
  pkgs,
  lib,
  isDesktop,
  opnix,
  ...
}: {
  imports = [
    opnix.homeManagerModules.default
  ];

  home = {
    stateVersion = "24.11";

    username = "rose";
    homeDirectory = "/home/rose";

    packages = with pkgs; [
      _1password-cli
      _1password-gui
      vesktop
      alejandra
      imhex
      direnv
      gitkraken
      qpwgraph
      nautilus
      gnome-tweaks
      vlc
      binutils
      kx-aspe-cli
      openssl
      iperf3
      obsidian
      opnix.packages.${pkgs.system}.default
      (prismlauncher.override {
        # Java runtimes available to Prism Launcher
        jdks = [
          graalvm-ce
          zulu8
          zulu17
          zulu
        ];
      })
    ];
  };

  gtk = {
    enable = true;

    iconTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };

    cursorTheme = {
      name = "Adwaita";
    };
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      cursor-size = 24;
    };
  };

  programs = {
    home-manager.enable = true;
    obs-studio.enable = isDesktop;

    chromium = {
      enable = isDesktop;
      package = pkgs.ungoogled-chromium;

      extensions = let
        chromium-extension = import ./../../util/chromium-extension.nix (lib.versions.major pkgs.ungoogled-chromium.version);
      in [
        # Web Scrobbler
        (chromium-extension {
          id = "hhinaapppaileiechjoiifaancjggfjm";
          sha256 = "sha256:0dsdygrl5gvyxn3y95xzfrmbgfr22iyhzrbv8ind6a8rj6l55x6f";
          version = "3.13.0";
        })

        # 1Password
        (chromium-extension {
          id = "aeblfdkhhhdcdjpifhhbdiojplfjncoa";
          sha256 = "sha256:0g79j2qsmnhg0fq3d2asj632v88cipcbq56aimgaqsxl7yv079i8";
          version = "8.10.72.27";
        })

        # Dark Reader
        (chromium-extension {
          id = "eimadpbcbfnmbkopoojfekhnkhdbieeh";
          sha256 = "sha256:0x9l2m260y0g7l7w988sghgh8qvfghydx8pbd1gd023zkqf1nrv2";
          version = "4.9.103";
        })

        # uBlock Origin
        (chromium-extension {
          id = "cjpalhdlnbpafiamejdnhcphjbkeiagm";
          sha256 = "sha256:1lnk0k8zy0w33cxpv93q1am0d7ds2na64zshvbwdnbjq8x4sw5p6";
          version = "1.63.2";
        })

        # SponsorBlock
        (chromium-extension {
          id = "mnjggcdmjocbbbhaepdhchncahnbgone";
          sha256 = "sha256:0m5gnhrb4wldx9kyypnbh1pal1i6krwpry17lhyw7xgd93bmrbnm";
          version = "5.12.1";
        })
      ];
    };

    vscode = {
      enable = isDesktop;
      package = pkgs.vscodium;
      mutableExtensionsDir = false;
      enableUpdateCheck = true;
      enableExtensionUpdateCheck = true;

      extensions = with pkgs.vscode-extensions; [
        bbenoist.nix
        gruntfuggly.todo-tree
        rust-lang.rust-analyzer
        tamasfe.even-better-toml
        thenuprojectcontributors.vscode-nushell-lang
        vscode-icons-team.vscode-icons
        mkhl.direnv
        svelte.svelte-vscode
        ms-python.python
      ];

      userSettings = {
        "editor.formatOnSave" = true;
        "workbench.iconTheme" = "vscode-icons";
        "window.titleBarStyle" = "native";
        "editor.fontFamily" = "'Fira Code', 'monospace', monospace";
        "editor.fontLigatures" = true;
      };
    };

    git = {
      enable = true;
      userName = "Rose Kodsi-Hall";
      userEmail = "rose@hall.ly";

      extraConfig = {
        gpg.format = "ssh";
        "gpg \"ssh\"".program = "${lib.getExe' pkgs._1password-gui "op-ssh-signin"}";
        commit.gpgsign = true;
        user.signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL5oU0aUotQDUEL+WIlbwT6vk1G7w9v+E7+3aQQsYdNT";
        init.defaultBranch = "main";
      };
    };

    nushell = {
      enable = true;
      package = pkgs.nushell;
      configFile.source = ./config.nu;
    };

    carapace = {
      enable = true;
      package = pkgs.carapace;
      enableNushellIntegration = true;
    };

    starship = {
      enable = true;
      package = pkgs.starship;
      enableNushellIntegration = true;
    };

    feh = {
      enable = true;
      package = pkgs.feh;
      themes = {
        example = [
          "--info"
          "foo bar"
        ];
      };
    };

    alacritty = {
      enable = true;
      package = pkgs.alacritty;
      settings = {};
    };

    i3status-rust = {
      enable = true;
      bars = {
        bottom = {
          blocks = [
            {
              block = "cpu";
            }
            {
              alert = 10.0;
              block = "disk_space";
              format = " $icon root: $available.eng(w:2) ";
              info_type = "available";
              interval = 20;
              path = "/";
              warning = 20.0;
            }
            {
              block = "memory";
              format = " $icon $mem_total_used_percents.eng(w:2) ";
              format_alt = " $icon_swap $swap_used_percents.eng(w:2) ";
            }
            {
              block = "sound";
              click = [
                {
                  button = "left";
                  cmd = "pavucontrol";
                }
              ];
            }
            {
              block = "time";
              format = " $timestamp.datetime(f:'%a %d/%m %R') ";
              interval = 5;
            }
          ];
        };
      };
    };

    rofi = {
      enable = true;
      package = pkgs.rofi;
      font = "Fira Code 16";
      extraConfig = {
        modes = "window,drun,run,ssh,combi";
      };
    };
  };

  services = {
    gpg-agent.enableNushellIntegration = true;
  };

  systemd.user.services.set-wallpaper = {
    Unit = {
      description = "Set my wallpaper";
    };

    Serivce = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "set-wallpaper.nu" ''
        #${pkgs.nushell}/bin/nu
        ${pkgs.feh}/bin/feh -bg ${./wallpaper.png}
      '';
    };
  };

  xsession.windowManager.i3 = rec {
    enable = true;
    package = pkgs.i3;
    config = {
      modifier = "Mod1";
      keybindings = {
        "${config.modifier}+0" = "workspace number 10";
        "${config.modifier}+1" = "workspace number 1";
        "${config.modifier}+2" = "workspace number 2";
        "${config.modifier}+3" = "workspace number 3";
        "${config.modifier}+4" = "workspace number 4";
        "${config.modifier}+5" = "workspace number 5";
        "${config.modifier}+6" = "workspace number 6";
        "${config.modifier}+7" = "workspace number 7";
        "${config.modifier}+8" = "workspace number 8";
        "${config.modifier}+9" = "workspace number 9";
        "${config.modifier}+Down" = "focus down";
        "${config.modifier}+Left" = "focus left";
        "${config.modifier}+Return" = "exec ${pkgs.alacritty}/bin/alacritty";
        "${config.modifier}+Right" = "focus right";
        "${config.modifier}+Shift+0" = "move container to workspace number 10";
        "${config.modifier}+Shift+1" = "move container to workspace number 1";
        "${config.modifier}+Shift+2" = "move container to workspace number 2";
        "${config.modifier}+Shift+3" = "move container to workspace number 3";
        "${config.modifier}+Shift+4" = "move container to workspace number 4";
        "${config.modifier}+Shift+5" = "move container to workspace number 5";
        "${config.modifier}+Shift+6" = "move container to workspace number 6";
        "${config.modifier}+Shift+7" = "move container to workspace number 7";
        "${config.modifier}+Shift+8" = "move container to workspace number 8";
        "${config.modifier}+Shift+9" = "move container to workspace number 9";
        "${config.modifier}+Shift+Down" = "move down";
        "${config.modifier}+Shift+Left" = "move left";
        "${config.modifier}+Shift+Right" = "move right";
        "${config.modifier}+Shift+Up" = "move up";
        "${config.modifier}+Shift+c" = "reload";
        "${config.modifier}+Shift+e" = "exec i3-nagbar -t warning -m 'Do you want to exit i3?' -b 'Yes' 'i3-msg exit'";
        "${config.modifier}+Shift+minus" = "move scratchpad";
        "${config.modifier}+Shift+q" = "kill";
        "${config.modifier}+Shift+r" = "restart";
        "${config.modifier}+Shift+space" = "floating toggle";
        "${config.modifier}+Up" = "focus up";
        "${config.modifier}+a" = "focus parent";
        "${config.modifier}+d" = "exec ${pkgs.writeShellScript "rofi-open.sh" "${pkgs.rofi}/bin/rofi -show combi -combi-modes \"window,drun\""}";
        "${config.modifier}+c" = "exec ${pkgs.rofi}/bin/rofi -show window";
        "${config.modifier}+e" = "layout toggle split";
        "${config.modifier}+f" = "fullscreen toggle";
        "${config.modifier}+h" = "split h";
        "${config.modifier}+minus" = "scratchpad show";
        "${config.modifier}+r" = "mode resize";
        "${config.modifier}+s" = "layout stacking";
        "${config.modifier}+space" = "focus mode_toggle";
        "${config.modifier}+v" = "split v";
        "${config.modifier}+w" = "layout tabbed";
      };
      modes = {
        resize = {
          Down = "resize grow height 10 px or 10 ppt";
          Left = "resize shrink width 10 px or 10 ppt";
          Right = "resize grow width 10 px or 10 ppt";
          Up = "resize shrink height 10 px or 10 ppt";

          Escape = "mode default";
          Return = "mode default";
        };
      };
      bars = [
        {
          position = "bottom";
          fonts = {
            names = ["Fira Code"];
            style = "Bold";
            size = 12.0;
          };
          statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs ~/.config/i3status-rust/config-bottom.toml";
        }
      ];
    };
    extraConfig = ''
      # Plasma compatibility improvementsah o
      for_window [window_role="pop-up"]mostl floating enable
      for_window [window_role="task_dialog"] floating enable

      for_window [class="yakuake"] floating enable
      for_window [class="systemsettings"] floating enable
      for_window [class="plasmashell"] floating enable
      for_window [class="Plasma"] floating enable, border none
      for_window [title="plasma-desktop"] floating enable, border none
      for_window [title="win7"] floating enable, border none
      for_window [class="krunner"] floating enable, border none
      for_window [class="Kmix"] floating enable, border none
      for_window [class="Klipper"] floating enable, border none
      for_window [class="Plasmoidviewer"] floating enable, border none
      for_window [class="(?i)*nextcloud*"] floating disable
      for_window [class="plasmashell" window_type="notification"] border none
      no_focus [class="plasmashell" window_type="notification"]

      for_window [title=".* - Chromium"] border none
      for_window [title=".* - VSCodium"] border none
      for_window [title="Vesktop"] border none

      for_window [title="Desktop @ QRect.*"] kill, floating enable, border none
    '';
  };
}
