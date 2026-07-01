{
  pkgs,
  lib,
  ...
}:
{
  networking = {
    firewall.enable = false;
    # Use systemd-resolved inside the container
    # Workaround for bug https://github.com/NixOS/nixpkgs/issues/162686
    useHostResolvConf = lib.mkForce false;
  };

  services.traccar = {
    enable = true;
  };

  users = {
    users.traccar = {
      isSystemUser = true;
      uid = 500;
      description = "Traccar";
      group = "nogroup";
    };
  };

  systemd.services.traccar = {
    serviceConfig = {
      DynamicUser = lib.mkForce false;
      User = "traccar";
      StateDirectory = lib.mkForce "";
      ReadWritePaths = "/var/lib/traccar";
    };
  };

  system.stateVersion = "26.11";
}
