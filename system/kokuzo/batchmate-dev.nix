{ pkgs, ... }:
# A dev instance of batchmate (github.com/rc-batchmates/batchmate-app) at
# batchmates-dev.hall.ly. It runs the app with its mock door system, never the
# real one. The image is built on kokuzo from a checkout of the app and kept in
# the local registry, which survives reboots (/ is tmpfs):
#
#   sudo podman build -t localhost:5000/batchmate-dev:latest -f deploy/dev/Dockerfile .
#   sudo podman push --tls-verify=false localhost:5000/batchmate-dev:latest
#   sudo systemctl restart podman-batchmate-dev
let
  port = 8790;
in
{
  # Its database. Created once with:
  #   sudo zfs create -o mountpoint=legacy apps/batchmate-dev
  fileSystems."/persist/batchmate-dev" = {
    device = "apps/batchmate-dev";
    fsType = "zfs";
    depends = [ "/" ];
  };

  opnix = {
    secrets = [
      {
        # BETTER_AUTH_SECRET, RC_CLIENT_ID and RC_CLIENT_SECRET, one per line.
        path = "batchmate-dev.env";
        reference = "op://Services/batchmate-dev env/notesPlain";
      }
    ];
    services = [ "podman-batchmate-dev.service" ];
  };

  virtualisation.oci-containers.containers.batchmate-dev = {
    image = "localhost:5000/batchmate-dev:latest";
    autoStart = true;
    ports = [ "127.0.0.1:${toString port}:8787" ];
    volumes = [ "/persist/batchmate-dev:/data" ];
    environment.BASE_URL = "https://batchmates-dev.hall.ly";
    environmentFiles = [ (pkgs.asOpnixPath "batchmate-dev.env") ];
    # The local registry is plain HTTP.
    extraOptions = [ "--tls-verify=false" ];
  };

  services.cloudflared.tunnels."9407ea8e-0f2c-45d0-9265-9797d2bbe5d1".ingress = {
    "batchmates-dev.hall.ly" = "http://localhost:${toString port}";
  };
}
