{pkgs, ...}: {
  services = {
    sonarr.enable = true;
    lidarr.enable = true;
    bazarr.enable = true;
  };
}
