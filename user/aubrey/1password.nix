{ isDesktop, ... }: {
  xdg.configFile."1Password/ssh/agent.toml" = {
    enable = isDesktop;
    force = true;
    text = ''
      [[ssh-keys]]
      vault = "Private"
    '';
  };
}
