{ pkgs, ... }: {
  users = {
    users.traccar = {
      isSystemUser = true;
      uid = 501;
      name = "Traccar";
      group = "traccar";
    };
    groups.traccar = {
      gid = 501;
      name = "traccar";
    };
  };

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
