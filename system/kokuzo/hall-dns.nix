{
  config,
  pkgs,
  ...
}: {
  opnix = {
    secrets = [
      {
        path = "cloudflare/dynamicDnsToken";
        reference = "op://Services/hall.ly Dynamic DNS Token/password";
      }
    ];

    services = ["dynamic-dns.service"];
  };

  systemd.services.dynamic-dns = {
    description = "Dynamic DNS updater for hall.ly";
    wantedBy = ["multi-user.target"];
    script = "${pkgs.nushell}/bin/nu ${./hall-dns.nu} ${pkgs.asOpnixPath "cloudflare/dynamicDnsToken"}";
  };
}
