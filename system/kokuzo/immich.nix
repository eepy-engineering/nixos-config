{ pkgs, lib, ... }: {
  users = {
    users.immich = {
      uid = 502;
      name = "immich";
      group = "immich";
      isSystemUser = true;
    };
    groups.immich.gid = 502;
  };
  environment.systemPackages = [
    pkgs.immich-cli
  ];
  containers = {
    immich = {
      autoStart = true;
      config =
        { ... }:
        {
          services = {
            immich = {
              enable = true;
              database = {
                enable = true;
              };
              mediaLocation = "/mnt/tank/immich";
              host = "0.0.0.0";
            };
            postgresql = {
              enableTCPIP = false;
              settings = {
                listen_addresses = lib.mkForce "";
              };
            };
          };
          users = {
            users.immich.uid = 502;
            groups.immich.gid = 502;
          };
          nixpkgs.pkgs = pkgs;
          system.stateVersion = "26.11";
        };
      bindMounts = {
        "/mnt/tank/immich" = {
          hostPath = "/mnt/tank/immich";
          isReadOnly = false;
        };
        "/mnt/apps/immich-postgres-data" = {
          hostPath = "/mnt/apps/immich-postgres-data";
          isReadOnly = false;
        };
      };
    };
  };
}
