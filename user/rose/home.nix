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

    packages = with pkgs;
      []
      ++ (
        if isDesktop
        then [
          _1password-cli
          _1password-gui
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
          rose-pine-gtk-theme
          rose-pine-cursor
          zulip
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
          (pkgs.python3.withPackages (python-pkgs:
            with python-pkgs; [
              numpy
            ]))
        ]
        else []
      );

    shell = {
      enableNushellIntegration = true;
    };
  };

  gtk = {
    enable = true;

    iconTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };

    theme = {
      name = "rose-pine";
      package = pkgs.rose-pine-gtk-theme;
    };

    cursorTheme = {
      name = "BreezeX-RosePine-Linux";
      package = pkgs.rose-pine-cursor;
    };

    gtk3.extraConfig.gtk-application-prefer-dark-theme = true;
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      cursor-size = 12;
      color-scheme = "prefer-dark";
    };
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "x-scheme-handler/discord" = "vesktop.desktop";
      "x-scheme-handler/gitkraken" = "GitKraken.desktop";

      "text/html" = "chromium.desktop";
      "x-scheme-handler/http" = "chromium.desktop";
      "x-scheme-handler/https" = "chromium.desktop";
      "x-scheme-handler/about" = "chromium.desktop";
      "x-scheme-handler/unknown" = "chromium.desktop";

      "appliction/json" = "codium.desktop";
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

        # Rosé Pine
        (chromium-extension {
          id = "noimedcjdohhokijigpfcbjcfcaaahej";
          sha256 = "sha256:06zrzs96bmrw67q4v5jn5f67l87am5h51qzw0hz4z78h6kz0as7v";
          version = "2.0.0";
        })
      ];
    };

    vscode = {
      enable = isDesktop;
      package = pkgs.vscodium;
      mutableExtensionsDir = false;

      profiles.default = {
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
          kamadorueda.alejandra
          mvllow.rose-pine
          dbaeumer.vscode-eslint
          editorconfig.editorconfig
          stylelint.vscode-stylelint
        ];

        userSettings = {
          "editor.formatOnSave" = true;
          "workbench.iconTheme" = "rose-pine-icons";
          "workbench.colorTheme" = "Rosé Pine";
          "window.titleBarStyle" = "custom";
          "editor.fontFamily" = "'Fira Code', 'monospace', monospace";
          "editor.fontLigatures" = true;
        };
      };
    };

    vesktop = {
      enable = isDesktop;
      # package = pkgs.vesktop.override {
      #   vencord = pkgs.vencord.overrideAttrs {
      #     src = pkgs.fetchFromGitHub {
      #       owner = "roobscoob";
      #       repo = "Vencord";
      #       rev = "7beb90cbc1277725e6c17d5a7aca9f4208d83266";
      #       hash = "sha256-8oNIveNRHfFAha5Z0Az3H3PROOo6u10HDY4olCyrkrU=";
      #     };
      #   };
      # };

      package = pkgs.vesktop;

      vencord = {
        useSystem = true;

        themes = {
          "quick-css.theme" = ./vencord-themes/quick-css.theme.css;
          "system24-catppuccin-macchiato.theme" = ./vencord-themes/system24-catppuccin-macchiato.theme.css;
          "system24-catppuccin-mocha.theme" = ./vencord-themes/system24-catppuccin-mocha.theme.css;
          "system24-nord.theme" = ./vencord-themes/system24-nord.theme.css;
          "system24-rose-pine-moon.theme" = ./vencord-themes/system24-rose-pine-moon.theme.css;
          "system24-rose-pine.theme" = ./vencord-themes/system24-rose-pine.theme.css;
          "system24-tokyo-night.theme" = ./vencord-themes/system24-tokyo-night.theme.css;
          "system24-vencord.theme" = ./vencord-themes/system24-vencord.theme.css;
          "system24.theme" = ./vencord-themes/system24.theme.css;
        };

        settings = {
          autoUpdate = false;
          autoUpdateNotification = true;
          useQuickCss = false;
          egarPatches = false;
          enabledThemes = ["system24-rose-pine.theme.css" "quick-css.theme.css"];
          enableReactDevtools = true;
          frameless = false;
          transparent = false;
          winCtrlQ = true;
          disableMinSize = true;
          winNativeTitleBar = false;
          notifyAboutUpdates = true;

          notifications = {
            timeout = 5000;
            position = "bottom-right";
            useNative = "not-focused";
            logLimit = 50;
          };

          cloud = {
            authenticated = true;
            url = "https://api.vencord.dev/";
            settingsSync = false;
            settingsSyncVersion = 0;
          };

          plugins = {
            BadgeAPI.enabled = true;
            CommandsAPI.enabled = true;
            ContextMenuAPI.enabled = true;
            MemberListDecoratorsAPI.enabled = true;
            MessageAccessoriesAPI.enabled = true;
            MessageDecorationsAPI.enabled = true;
            MessageEventsAPI.enabled = true;
            MessagePopoverAPI.enabled = true;
            NoticesAPI.enabled = true;
            ServerListAPI.enabled = true;
            ChatInputButtonAPI.enabled = true;
            MessageUpdaterAPI.enabled = true;
            UserSettingsAPI.enabled = true;
            DynamicImageModalAPI.enabled = true;

            SupportHelper.enabled = true;
            BetterStreamPreview.enabled = true;
            EmoteCloner.enabled = true;
            F8Break.enabled = true;
            ForceOwnerCrown.enabled = true;
            MoreKaomoji.enabled = true;
            MutualGroupDMs.enabled = true;
            NoF1.enabled = true;
            NoTypingAnimation.enabled = true;
            oneko.enabled = true;
            PreviewMessage.enabled = true;
            ReactErrorDecoder.enabled = true;
            ReverseImageSearch.enabled = true;
            ThemeAttributes.enabled = true;
            Unindent.enabled = true;
            ValidUser.enabled = true;
            VencordToolbox.enabled = true;
            WebKeybinds.enabled = true;
            WhoReacted.enabled = true;
            FixYoutubeEmbeds.enabled = true;
            FriendsSince.enabled = true;
            ImageLink.enabled = true;
            ServerInfo.enabled = true;
            AutomodContext.enabled = true;
            CopyEmojiMarkdown.enabled = true;
            MaskedLinkPaste.enabled = true;
            NoDefaultHangStatus.enabled = true;
            NoOnboardingDelay.enabled = true;
            ReplyTimestamp.enabled = true;
            ShowTimeoutDuration.enabled = true;
            ValidReply.enabled = true;
            VoiceDownload.enabled = true;
            YoutubeAdblock.enabled = true;
            CopyFileContents.enabled = true;
            FullSearchContext.enabled = true;
            FullUserInChatbox.enabled = true;
            WebScreenShareFixes.enabled = true;
            DisableDeepLinks.enabled = true;

            NoTrack = {
              enabled = true;
              disableAnalytics = true;
            };

            Settings = {
              enabled = true;
              settingsLocation = "top";
            };

            AnonymiseFileNames = {
              enabled = true;
              anonymiseByDefault = true;
              method = 0;
              randomizedLength = 7;
              consistent = "image";
            };

            CallTimer = {
              enabled = true;
              format = "human";
            };

            CrashHandler = {
              enabled = true;
              attemptToPreventCrashes = true;
              attemptToNavigateToHome = false;
            };

            Experiments = {
              enabled = true;
              enableIsStaff = false;
              toolbarDevMenu = false;
            };

            LastFMRichPresence = {
              enabled = true;
              hideWithSpotify = false;
              shareUsername = true;
              statusName = "music";
              nameFormat = "song";
              useListeningStatus = "true";
              missingArt = "placeholder";
              apiKey = "3235e0165b2c0ad38eb22530f64e863e";
              username = "roobscoob";
              showLastFmLogo = true;
              shareSong = true;
              hideWithActivity = false;
            };

            MessageLinkEmbeds = {
              enabled = true;
              automodEmbeds = "never";
              listMode = "blacklist";
              idList = "";
              messageBackgroundColor = true;
            };

            MessageLogger = {
              enabled = true;
              deleteStyle = "overlay";
              ignoreBots = false;
              ignoreSelf = false;
              logEdits = true;
              logDeletes = true;
              collapseDeleted = true;
              inlineEdits = true;
            };

            PermissionsViewer = {
              enabled = true;
              permissionsSortOrder = 1;
              defaultPermissionsDropdownState = false;
            };

            PictureInPicutre = {
              enabled = true;
              loop = false;
            };

            PlatformIndicators = {
              enabled = true;
              colorMobileIndicator = true;
              list = true;
              badges = true;
              messages = true;
            };

            RelationshipsNotifier = {
              enabled = true;
              noticies = true;
              offlineRemovals = true;
              friends = true;
              friendRequestCancels = true;
              servers = true;
              groups = true;
            };

            ReviewDB = {
              enabled = true;
              notifyReviews = true;
              reviewsDropdownState = true;
              showWarning = true;
              hideBlockedUsers = true;
              hideTimestamps = false;
            };

            RoleColorEverywhere = {
              enabled = true;
              chatMentions = true;
              memberList = true;
              voiceUsers = true;
              reactorsList = true;
              colorChatMessages = false;
              pollResults = true;
            };

            SendTimestamps = {
              enabled = true;
              replaceMessageContents = true;
            };

            ServerListIndicators = {
              enabled = true;
              mode = 3;
            };

            ShowConnections = {
              enabled = true;
              iconSpacing = 1;
              iconSize = 32;
            };

            ShowHiddenChannels = {
              enabled = true;
              showMode = 0;
              hideUnreads = true;
              defaultAllowedUsersAndRolesDropdownState = true;
            };

            ShowMeYourName = {
              enabled = true;
              displayNames = false;
              mode = "nick-user";
              inReplies = false;
            };

            SilentTyping = {
              enabled = true;
              showIcon = true;
              isEnabled = false;
              contextMenu = true;
            };

            SpotifyCrack = {
              enabled = true;
              noSpotifyAutoPause = true;
              keepSpotifyActivityOnIdle = false;
            };

            Translate = {
              enabled = true;
              showChatBarButton = true;
              serivce = "google";
              autoTranslate = false;
              showAutoTranslateTooltip = true;
              receivedInput = "auto";
              receivedOutput = "en";
              sentInput = "auto";
              sentOutput = "ja";
              showAutoTranslateAlert = false;
            };

            TypingIndicator = {
              enabled = true;
              includeMutedChannels = true;
              includeCurrentChannel = true;
              includeBlockedUsers = false;
              indicatorMode = 3;
            };

            TypingTweaks = {
              enabled = true;
              alternativeFormatting = true;
              showRoleColors = true;
              showAvatars = true;
            };

            UserVoiceShow = {
              enabled = true;
              showVoiceChannelSectionHeader = true;
              showInUserProfileModal = true;
              showInMemberList = true;
              showInMessages = true;
            };

            ViewIcons = {
              enabled = true;
              format = "png";
              imgSize = "1024";
            };

            ViewRaw = {
              enabled = true;
              clickMethod = "left";
            };

            VoiceMessages = {
              enabled = true;
              noiseSuppression = true;
              echoCancellation = true;
            };

            VolumeBooster = {
              enabled = true;
              multiplier = 2;
            };

            NewGuildSettings = {
              enabled = true;
              guild = true;
              everyone = true;
              role = true;
              events = true;
              highlights = true;
              messages = 3;
              showAllChannels = true;
            };

            ShowHiddenThings = {
              enabled = true;
              showTimeouts = true;
              showInvitesPaused = true;
              showModView = true;
              disableDiscoveryFilters = true;
              disableDisallowedDiscoveryFilters = true;
            };

            BetterSessions = {
              enabled = true;
              backgroundCheck = false;
            };

            ImplicitRelationships = {
              enabled = true;
              sortByAffinity = true;
            };

            UnlockedAvatarZoom = {
              enabled = true;
              zoomMultiplier = 4;
            };

            CtrlEnterSend = {
              enabled = true;
              submitRule = "ctrl+enter";
              sendMessageInTheMiddleOfACodeBlock = true;
            };

            CustomIdle = {
              enabled = true;
              idleTimeout = 10;
              remainInIdle = true;
            };

            MessageLatency = {
              enabled = true;
              latency = 2;
              detectDiscordKotlin = true;
              showMillis = true;
            };

            AccountPanelServerProfile = {
              enabled = true;
              prioritizeServerProfile = false;
            };

            MentionAvatars = {
              enabled = true;
              showAtSymbol = true;
            };

            UserMessagesPronouns = {
              enabled = true;
              showInMessages = true;
              showSelf = true;
              pronounSource = 1;
              pronounsFormat = "LOWERCASE";
              showInProfile = true;
            };
          };
        };
      };

      settings = {
        discordBranch = "stable";
        minimizeToTray = true;
        arRPC = true;
        splashColor = "rgb(192, 189, 219)";
        splashBackground = "rgb(26, 24, 37)";
        spellCheckLanguages = ["en-US" "en"];
        customTitleBar = false;
        staticTitle = true;
        hardwareAcceleration = true;
        enableMenu = false;
        enableSplashScreen = true;
        splashTheming = true;
        tray = true;
        clickTrayToShowHide = false;
        disableMinSize = false;
        disableSmoothScroll = false;
        appBadge = true;
        openLinksWithElectron = false;
      };
    };

    git = {
      enable = true;
      userName = "Rose Kodsi-Hall";
      userEmail = "rose@hall.ly";

      extraConfig = {
        gpg.format = "ssh";
        "gpg \"ssh\"".program = "${lib.getExe' pkgs._1password-gui "op-ssh-sign"}";
        commit.gpgsign = true;
        user.signingkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL5oU0aUotQDUEL+WIlbwT6vk1G7w9v+E7+3aQQsYdNT";
        init.defaultBranch = "main";
      };
    };

    ssh = {
      enable = true;
      extraConfig = ''
        Host *
          IdentityAgent ~/.1password/agent.sock
          ForwardAgent yes
      '';
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
      settings = {
        env_var.__NIX_SHELL_CONTENTS = {
          variable = "__NIX_SHELL_CONTENTS";
          default = "";
          format = "[$env_value]($style)";
          style = "yellow";
        };
        nix_shell = {
          format = "";
        };
      };
    };

    feh = {
      enable = isDesktop;
      package = pkgs.feh;
    };

    alacritty = {
      enable = isDesktop;
      package = pkgs.alacritty;
      settings = {};
    };

    rofi = {
      enable = isDesktop;
      package = pkgs.rofi;
      theme = ./rose-pine.rasi;
      extraConfig = {
        modes = "window,drun,run,ssh,combi";
      };
    };

    onepassword-secrets = {
      enable = isDesktop;
      secrets = [
        {
          path = ".secrets/polybar/github";
          reference = "op://5dhshqqml7vv6bgttzilsgqaoq/Github Polybar/credential";
        }
      ];
    };
  };

  home.file.".config/1Password/ssh/agent.toml" = {
    enable = true;
    force = true;
    text = ''
      [[ssh-keys]]
      vault = "Private"

      [[ssh-keys]]
      vault = "Rose"
    '';
  };

  services = {
    gpg-agent.enableNushellIntegration = true;

    picom = {
      enable = isDesktop;
      package = pkgs.picom;
      vSync = true;
      backend = "glx";
      activeOpacity = 1;
      inactiveOpacity = 1;
      settings = {
        unredir-if-possible = false;
      };
    };

    polybar = {
      enable = isDesktop;
      package = pkgs.polybarFull;
      script = ''
        for m in $(${pkgs.polybarFull}/bin/polybar --list-monitors | ${pkgs.toybox}/bin/cut -d":" -f1); do
          ${pkgs.polybarFull}/bin/polybar --reload $m &
        done
      '';
      extraConfig = ''
        include-file = ${./polybar}/lib/shapes/config-DP0.ini
        include-file = ${./polybar}/lib/shapes/config-DP2.ini
        include-file = ${./polybar}/lib/shapes/config-DP4.ini
      '';
    };

    flameshot = {
      enable = isDesktop;
      package = pkgs.flameshot;
    };
  };

  systemd.user.startServices = true;

  systemd.user.services.set-wallpaper = {
    Unit = {
      Description = "Set my wallpaper";
      After = ["graphical-session.target"];
    };

    Service = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "set-wallpaper.nu" ''
        #${pkgs.nushell}/bin/nu
        ${pkgs.feh}/bin/feh --no-xinerama --bg-max ${./wallpaper-stretch.png}
      '';
    };
  };

  xsession.windowManager.i3 = rec {
    enable = isDesktop;
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
      bars = [];
    };
    extraConfig = ''
      for_window [title=".* - Chromium"] border none
      for_window [title=".* - VSCodium"] border none
      for_window [title="Vesktop"] border none

      for_window [title="Desktop @ QRect.*"] kill, floating enable, border none
    '';
  };
}
