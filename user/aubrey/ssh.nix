_: {
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = {
      "*" = {
        forwardAgent = true;
        identityAgent = "~/.1password/agent.sock";
      };
      "sanae6.ca" = {
        user = "sanae";
      };
    };
  };
}
