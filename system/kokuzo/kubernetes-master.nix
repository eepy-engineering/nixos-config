{
  config,
  pkgs,
  lib,
  ...
}: {
  services.k3s = {
    enable = true;
    role = "server";
    token = "todo get a real key dumbass";
    clusterInit = true;
    extraFlags = [
      "--tls-san=100.70.181.9"
      "--tls-san=kokuzo.tailc38f.ts.net"
      "--node-ip=0.0.0.0"
      "--node-external-ip=100.70.181.9"
      "--debug"
    ];
    manifests.traefik-config.source = ./traefik-config.yaml;
  };

  users.users.filebrowser = {
    description = "Filebrowser";
    isNormalUser = true;
    createHome = false;
  };

  services.dockerRegistry = {
    enable = true;
    storagePath = "/persist/docker-registry";
    listenAddress = "0.0.0.0";
  };

  systemd = {
    services.k3s = {
      serviceConfig = {
        "LimitNOFILE" = lib.mkForce "infinity";
      };
    };
  };
}
