{ pkgs, ... }:
{
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "server";
    extraDaemonFlags = [ "--statedir=/persist/tailscale" ];
  };
}
