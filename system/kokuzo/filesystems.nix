{...}: {
  fileSystems."/mnt/tank/plex-media" = {
    device = "tank/nas/plex-media";
    fsType = "zfs";
    depends = ["/mnt/tank"];
  };

  fileSystems."/mnt/tank/plex-conf" = {
    device = "apps/plex-config";
    fsType = "zfs";
    depends = ["/mnt/tank"];
  };

  fileSystems."/persist/ssh-host-keys" = {
    device = "tank/nas/components/ssh-host-keys";
    fsType = "zfs";
    depends = ["/"];
  };

  fileSystems."/persist/docker-registry" = {
    device = "tank/nas/components/docker-registry";
    fsType = "zfs";
    depends = ["/"];
  };

  fileSystems."/persist/tailscale-nginx-cert" = {
    device = "tank/nas/components/tailscale-nginx-cert";
    fsType = "zfs";
    depends = ["/"];
  };

  fileSystems."/persist/gha-runner-store" = {
    device = "apps/gha-runner-store";
    fsType = "zfs";
    depends = ["/"];
  };

  fileSystems."/persist/mkworld-data" = {
    device = "tank/nas/components/mkworld-data";
    fsType = "zfs";
    depends = ["/"];
  };

  fileSystems."/persist/transmission" = {
    device = "tank/nas/components/transmission";
    fsType = "zfs";
    depends = ["/"];
  };

  fileSystems."/mnt/apps/filebrowser-config" = {
    device = "apps/filebrowser-config";
    fsType = "zfs";
    depends = ["/"];
  };

  fileSystems."/mnt/apps/immich-postgres-data" = {
    device = "apps/immich-postgres-data";
    fsType = "zfs";
    depends = ["/"];
  };

  fileSystems."/mnt/apps/tautulli-config" = {
    device = "apps/tautulli-config";
    fsType = "zfs";
    depends = ["/"];
  };
}
