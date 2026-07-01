{ pkgs, ... }: {
  containers = {
    firefly-iii = {
      autoStart = true;

      config = {
        imports = [ ./configuration.nix ];
        nixpkgs.pkgs = pkgs;
      };

      bindMounts = {
        "/mnt/firefly-iii" = {
          hostPath = "/persist/firefly-iii";
          isReadOnly = false;
        };
      };
    };
  };

}
