_: {
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings = {
      "*" = {
        ForwardAgent = true;
        IdentityAgent = "~/.1password/agent.sock";
      };
      "titan" = {
        User = "amt693";
        HostName = "titan.cs.uregina.ca";
        RemoteCommand = "bin/nu";
        RequestTTY = "force";
      };
      "os1" = {
        User = "amt693";
        HostName = "os1.cs.uregina.ca";
        ProxyJump = "titan";
        RemoteCommand = "bin/nu";
        RequestTTY = "force";
      };
      "catbox" = {
        User = "tetra";
      };
    };
  };
}
