{
  inputs,
  opnix,
  ...
}:
{
  home = {
    stateVersion = "24.11";

    username = "aubrey";
    homeDirectory = "/home/aubrey";
  };

  imports = [
    opnix.homeManagerModules.default
    inputs.catppuccin.homeModules.catppuccin
    ../components/nix-index.nix
    ./neovim
    ./nushell
    ./sway
    ./vesktop
    ./vscode
    ./editorconfig.nix
    ./flameshot.nix
    ./fzf.nix
    ./git.nix
    ./ime.nix
    ./jujutsu.nix
    ./nix.nix
    ./packages.nix
    ./rio.nix
    ./secrets.nix
    ./ssh.nix
    ./tmux.nix
    ./zed.nix
    ./zoxide.nix
    ./1password.nix
  ];
}
