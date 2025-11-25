{ pkgs, ... }:
{
  services.postgresql = {
    enable = true;
    enableTCPIP = true;
    authentication = pkgs.lib.mkOverride 10 ''
      #type database  DBuser  auth-method
      local all       all     trust

      # ipv4
      host  all      all     0.0.0.0/0   trust
      # ipv6
      host  all      all     ::1/128        trust
    '';

    ensureUsers = [
      {
        name = "aubrey";
        ensureClauses = {
          login = true;
          createdb = true;
          createrole = true;
        };
      }
      {
        name = "rose";
        ensureClauses = {
          login = true;
          createdb = true;
          createrole = true;
        };
      }
    ];
  };
}
