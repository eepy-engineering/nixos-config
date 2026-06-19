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

  services.nginx = {
    enable = true;
    virtualHosts."kerguelen" = {
      locations = {
        "/".alias = "${pkgs.traccar}/web/$1";
      };
    };
  };

  system.stateVersion = "26.11";
}
