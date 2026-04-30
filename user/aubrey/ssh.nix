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
      "titan" = {
        user = "amt693";
        hostname = "titan.cs.uregina.ca";
        extraOptions = {
          RemoteCommand = "bin/nu";
          RequestTTY = "force";
        };
      };
      "os1" = {
        user = "amt693";
        hostname = "os1.cs.uregina.ca";
        proxyJump = "titan";
        extraOptions = {
          RemoteCommand = "bin/nu";
          RequestTTY = "force";
        };
      };
      "catbox" = {
        user = "tetra";
      };
    };
  };
}
