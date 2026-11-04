{ isDesktop, lib, ... }: {
  xdg.configFile."1Password/ssh/agent.toml" = {
    enable = isDesktop;
    force = true;
    text = ''
      [[ssh-keys]]
      vault = "Private"
    '';
  };

  home.sessionVariables = {
    SSH_AUTH_SOCK = lib.mkIf isDesktop "$HOME/.1password/agent.sock";
  };
}
