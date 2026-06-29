{ pkgs, ... }: {
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "server";
    extraDaemonFlags = [ "--statedir=/persist/tailscale" ];
  };

  systemd.services.tailscaled = {
    serviceConfig = {
      ExecStart = [
        ""
        "${pkgs.tailscale}/bin/tailscaled --socket=/run/tailscale/tailscaled.sock --port=\${PORT} $FLAGS"
      ];
    };
  };
}
