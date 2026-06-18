{
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

  system.stateVersion = "26.11";
}
