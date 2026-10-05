{ pkgs, ... }: {
  containers = {
    forgejo = {
      autoStart = true;

      config = {
        imports = [ ./configuration.nix ];
        nixpkgs.pkgs = pkgs;
      };

      bindMounts = {
        "/mnt/forgejo" = {
          hostPath = "/persist/forgejo";
          isReadOnly = false;
        };
      };
    };
  };
  services.tailscale.serve = {
    enable = true;
    services = {
      aubyforge = {
        endpoints = {
          "tcp:22" = "tcp://localhost:2222";
        };
        advertised = true;
      };
    };
  };
}
