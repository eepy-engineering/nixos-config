{ pkgs, config, ... }:
let
  domain = "sanae6.ca";
in
{
  services = {
    nginx = {
      enable = true;
      virtualHosts = {
        ${domain} = {
          forceSSL = true;
          useACMEHost = domain;
          serverAliases = [
            "www.${domain}"
            "aubrey.${domain}"
          ];
          acmeRoot = null;
          locations = {
            "/" = {
              return = "200 '<html><body>Hi, I&apos;m Aubrey!</body></html>'";
              extraConfig = ''
                default_type text/html;
              '';
            };
            "~ ^/(\\.well-known/(oauth-|atproto-did)|@atproto|oauth|xrpc)" = {
              proxyPass = "http://localhost:3001";
              extraConfig = ''
                proxy_set_header X-Real-IP $remote_addr;
                proxy_set_header Host $host;
                proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                proxy_http_version 1.1;
                proxy_set_header Upgrade $http_upgrade;
                proxy_set_header Connection $connection_upgrade;
              '';
            };
            # "/.well-known/webfinger" = {
            #   return = ''200 '{"links":[{"href":"https://atlogin.net","rel":"http://openid.net/specs/connect/1.0/issuer"}],"subject":"acct:aubrey@sanae6.ca"}' '';
            #   extraConfig = ''
            #     default_type application/jrd+json;
            #   '';
            # };
          };
        };
        "git.${domain}" = {
          forceSSL = true;
          useACMEHost = domain;
          acmeRoot = null;
          locations = {
            "/".proxyPass = "http://localhost:3000";
          };
        };
        "traccar.${domain}" = {
          forceSSL = true;
          useACMEHost = domain;
          acmeRoot = null;
          locations = {
            "/client" = {
              extraConfig = ''
                rewrite /client(.*) /$1 break;
              '';
              proxyPass = "http://localhost:5055";
            };
            "/".proxyPass = "http://localhost:8082";
          };
        };
      };
    };
  };

  opnix = {
    secrets = [
      {
        path = "acme/cloudflared-token";
        reference = "op://Services/ukk5kznpvyely52fwzlrdyonxa/password";
      }
    ];
    users = [ config.services.nginx.user ];
    services = [ "acme-order-renew-sanae6.ca.service" ];
  };

  security.acme = {
    acceptTerms = true;
    defaults = {
      email = "aubrey@sanae6.ca";
      server = "https://acme-v02.api.letsencrypt.org/directory";
      dnsProvider = "cloudflare";
      environmentFile = pkgs.asOpnixPath "acme/cloudflared-token";
      extraLegoFlags = [ "--dns.propagation.disable-rns=true" ];
    };
    certs = {
      ${domain} = {
        extraDomainNames = [ "*.sanae6.ca" ];

        group = "nginx";
        reloadServices = [ "nginx" ];
        # location of your CLOUDFLARE_DNS_API_TOKEN=[value]
        # https://www.freedesktop.org/software/systemd/man/latest/systemd.exec.html#EnvironmentFile=
      };
    };
  };
}
