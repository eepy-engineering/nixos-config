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

  services.teamspeak3 = {
    enable = true;
    dataDir = "/mnt/teamspeak";
    openFirewall = true;
    openFirewallServerQuery = true;
  };

  system.stateVersion = "26.11";
}
