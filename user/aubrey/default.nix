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
          vesktop
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
        ]
        else []
      );
  };

  programs = {
    vscode = {
      enable = isDesktop;
      package = pkgs.vscodium;
      mutableExtensionsDir = false;
      enableUpdateCheck = true;
      enableExtensionUpdateCheck = true;

      userSettings = builtins.fromJSON (builtins.readFile ./vscode_settings.json);

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
  };
}
