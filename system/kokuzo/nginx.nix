{
  pkgs,
  config,
  ...
}: {
  services.nginx = {
    enable = true;
    clientMaxBodySize = "256m";
    virtualHosts = {
      "kokuzo" = {
        serverName = "kokuzo.tailc38f.ts.net";
        sslCertificateKey = "/persist/tailscale-nginx-cert/nginx.key";
        sslCertificate = "/persist/tailscale-nginx-cert/nginx.cert";
        forceSSL = true;
        extraConfig = "
          allow 192.168.0.0/16;
          allow 100.64.0.0/10;
          deny all;
        ";
        locations = {
          "/" = {
            recommendedProxySettings = true;
            proxyPass = "http://127.0.0.1:5000";
            priority = 100;
          };
          "/switch" = {
            root = "/mnt/tank/emu";
            extraConfig = "autoindex on;";
            priority = 80;
          };
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
