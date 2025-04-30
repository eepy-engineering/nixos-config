{
  config,
  pkgs,
  lib,
  ...
}: {
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
      gitkraken
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

  programs = {
    home-manager.enable = true;
    obs-studio.enable = true;

    chromium = {
      enable = true;
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
      enable = true;
      package = pkgs.vscodium;
      mutableExtensionsDir = false;

      profiles.default = {
        enableUpdateCheck = true;
        enableExtensionUpdateCheck = true;

        extensions = with pkgs.vscode-extensions; [
          bbenoist.nix
          kamadorueda.alejandra
          gruntfuggly.todo-tree
        ];

        userSettings = {
          "editor.formatOnSave" = true;
        };
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
  };
}
