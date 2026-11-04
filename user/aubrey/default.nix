{
  home = {
    stateVersion = "24.11";

    username = "aubrey";
    homeDirectory = "/home/aubrey";
  };

  imports = [
    # general
    ./packages.nix
    # ./secrets.nix
    ../components/nix-index.nix
    ./nix.nix

    # desktop
    ./fcitx5
    ./fonts.nix
    ./gtk.nix
    ./kdeconnect.nix
    ./sway

    # apps
    ./anki.nix
    ./vesktop
    ./zen.nix

    # terminal
    ./fzf.nix
    ./hyfetch.nix
    ./nushell
    # ./rio.nix
    ./tmux.nix
    ./wezterm
    ./zoxide.nix

    # development
    ./debugging.nix
    ./editorconfig.nix
    ./ghidra.nix
    ./git
    ./micro.nix
    ./misc.nix
    ./neovim
    ./vscode
    ./zed.nix

    ./1password.nix
    ./keepassxc.nix
    ./ssh
  ];
}
