{pkgs, ...}: {
  services.btrbk = {
    instances = {
      home-daily = {
        onCalendar = "daily";
        settings = {
          snapshot_preserve_min = "1m";
          snapshot_preserve = "3m";
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
