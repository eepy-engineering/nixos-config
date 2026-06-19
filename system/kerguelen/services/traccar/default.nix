{ pkgs, ... }: {
  containers = {
    traccar = {
      autoStart = true;

      config = {
        imports = [ ./configuration.nix ];
        nixpkgs.pkgs = pkgs;
      };

      bindMounts = {
        "/var/lib/traccar" = {
          hostPath = "/persist/traccar";
          isReadOnly = false;
        };
      };
    };
  };

}
