{ pkgs, config, ... }: {
  containers = {
    owntracks = {
      autoStart = true;
      # privateNetwork = true;
      # hostAddress = "192.168.4.1";
      # localAddress = "192.168.8.1";
      # hostAddress6 = "fc04::1";
      # localAddress6 = "fc08::2";
      forwardPorts = map (port: {
        hostPort = port;
      }) config.containers.owntracks.config.networking.firewall.allowedTCPPorts;
      config = { ... }: {
        imports = [ ./configuration.nix ];
        nixpkgs.pkgs = pkgs;
      };
      bindMounts = {
        "/mnt/owntracks" = {
          hostPath = "/persist/owntracks";
          isReadOnly = false;
        };
      };
    };
  };

}
