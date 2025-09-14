{
  xdg.configFile."1Password/ssh/agent.toml" = {
    enable = true;
    force = true;
    text = ''
      [[ssh-keys]]
      vault = "Private"
    '';
  };
}
