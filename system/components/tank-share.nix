{lib, ...}: {
  fileSystems."/mnt/tank" = {
    device = "//shared-server-store/tank";
    fsType = "cifs";
    options = [
      (import ../../util/cifs-options.nix lib {
        x-systemd = {
          automount = true;
          idle-timeout = 60;
          device-timeout = "5s";
          mount-timeout = "5s";
        };

        noauto = true;

        credentials = "/var/lib/opnix/secrets/samba/credentials";
      })
    ];
  };
}
