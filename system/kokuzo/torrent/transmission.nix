{
  pkgs,
  config,
  ...
}:
{
  services.transmission = {
    enable = true;
    home = "/persist/transmission";
    settings = {
      rpc-bind-address = "0.0.0.0";
      rpc-whitelist-enabled = false;
      rpc-host-whitelist-enabled = false;
      bind-address-ipv4 = "0.0.0.0"; # overwritten by script
      bind-address-ipv6 = "::1"; # never bind to any ipv6, pia doesn't support it
      port-forwarding-enabled = false; # leaks public ip currently
    };
  };
  services.pia-vpn.forwardingPort = config.services.transmission.settings.peer-port;
  systemd.services.transmission =
    let
      settingsDir = "${config.services.transmission.home}/.config/transmission-daemon";
    in
    {
      requires = [ "wg-pia-setup.service" ];
      environment = {
        TR_CURL_SSL_NO_VERIFY = "1";
      };
      serviceConfig = {
        ExecStartPre = [
          "+${pkgs.writeNushellScript "set-bind-address" ''
            loop {
              if ("/tmp/pia.ip" | path exists) { break }
              sleep 1sec
            }

            mut json = open ${settingsDir}/settings.json;
            let ip = open /tmp/pia.ip
            $json = $json | upsert "bind-address-ipv4" $ip
            $json | save -f ${settingsDir}/settings.json
          ''}"
        ];
      };
    };
}
