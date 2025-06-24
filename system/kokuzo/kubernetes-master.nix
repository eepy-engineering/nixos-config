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
      "--node-ip=192.168.2.1"
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

  services.nginx = {
    enable = true;
    clientMaxBodySize = "256m";
    virtualHosts = {
      "kokuzo" = {
        serverName = "kokuzo.tailc38f.ts.net";
        sslCertificateKey = "/persist/tailscale-nginx-cert/nginx.key";
        sslCertificate = "/persist/tailscale-nginx-cert/nginx.cert";
        forceSSL = true;
        locations."/" = {
          extraConfig = "deny 100.67.130.106;";
          recommendedProxySettings = true;
          proxyPass = "http://127.0.0.1:5000";
        };
      };
      "s3.hall.ly" = {
        serverName = "s3.hall.ly";
        root = "/mnt/tank/s3";
        locations."/" = {};
      };
    };
  };

  systemd = {
    services.k3s = {
      serviceConfig = {
        "LimitNOFILE" = lib.mkForce "infinity";
      };
    };
    services.tailscale-cert-refresh = {
      requires = ["network-online.target"];
      requiredBy = ["nginx.service"];
      script = ''
        ${pkgs.tailscale}/bin/tailscale cert --cert-file /persist/tailscale-nginx-cert/nginx.cert --key-file /persist/tailscale-nginx-cert/nginx.key kokuzo.tailc38f.ts.net
        chown ${config.services.nginx.user}:${config.services.nginx.group} /persist/tailscale-nginx-cert/nginx.cert /persist/tailscale-nginx-cert/nginx.key
      '';
      serviceConfig = {
        Type = "oneshot";
      };
    };

    timers.tailscale-cert-refresh = {
      wantedBy = ["timers.target"];
      requires = ["network-online.target"];
      timerConfig = {
        OnCalendar = "Sat 00:00:00";
        Persistent = true;
        Unit = ["tailscale-cert-refresh.service"];
      };
    };
  };
}
