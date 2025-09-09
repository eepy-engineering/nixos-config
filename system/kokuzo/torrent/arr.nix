{pkgs, ...}: {
  # opnix.services = ["pre-lidarr.service"];
  # systemd.services.pre-lidarr = {
  #   description = "setup lidarr env var";
  #   requires = ["wg-pia-setup.service"];
  #   requiredBy = ["lidarr.service"];

  #   script = "${pkgs.writeNushellScript "prepare-lidarr.nu" ''
  #     let ip = open /tmp/pia.ip;
  #     $"LIDARR__SERVER__BINDADDRESS=($ip)" | save -f /tmp/lidarr.config
  #   ''}";
  # };
  services = {
    sonarr.enable = true;
    lidarr = {
      enable = true;
      # environmentFiles = [
      #   "/tmp/lidarr.config"
      # ];
    };
  };
}
