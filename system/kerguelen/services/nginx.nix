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
          locations."/" = {
            return = "200 '<html><body>Hi, I&apos;m Aubrey!</body></html>'";
            extraConfig = ''
              default_type text/html;
            '';
          };
        };
        "traccar.${domain}" = {
          forceSSL = true;
          useACMEHost = domain;
          # locations."/" = {
          # proxyPass = "http://localhost:8082";
          # };
          locations = {
            "/client" = {
              extraConfig = ''
                rewrite /client(.*) /$1 break;
              '';
              proxyPass = "http://localhost:5055";
            };
            "/".proxyPass = "http://localhost:8082";
            "/.well-known/".root = "/var/lib/acme/acme-challenge/";
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
    };
    certs = {
      ${domain} = {
        domain = "*.${domain}";
        group = "nginx";
        dnsProvider = "cloudflare";
        # location of your CLOUDFLARE_DNS_API_TOKEN=[value]
        # https://www.freedesktop.org/software/systemd/man/latest/systemd.exec.html#EnvironmentFile=
        environmentFile = pkgs.asOpnixPath "acme/cloudflared-token";
      };
    };
  };
}
