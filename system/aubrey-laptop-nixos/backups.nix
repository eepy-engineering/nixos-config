{pkgs, ...}: {
  services.btrbk = {
    instances = {
      home-daily = {
        onCalendar = "daily";
        settings = {
          ssh_identity = builtins.toString ../../id_ed25519;
          ssh_user = "btrbk";
          snapshot_preserve_min = "1m";
          snapshot_preserve = "3m";
          # target = "raw ssh://shared-vm-nixos/mnt/tank/home/aubrey/btrfsSnapshots";
          volume = {
            "/" = {
              subvolume = "home";
              snapshot_dir = "/snapshots";
            };
          };
        };
      };
      home = {
        onCalendar = "hourly";
        settings = {
          timestamp_format = "long";
          snapshot_preserve_min = "1w";
          snapshot_preserve = "2w";
          volume = {
            "/" = {
              snapshot_dir = "/snapshots";
              subvolume = "home";
            };
          };
        };
      };
    };
  };
  systemd.tmpfiles.rules = [
    "d /snapshots 0755 root root"
  ];
}
