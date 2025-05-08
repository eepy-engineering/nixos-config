{
  isDesktop,
  config,
  lib,
  ...
}: {
  options = {
    opnix.secrets =
      lib.mkOption {
        type = lib.types.listOf lib.types.attrs;
        default = [];
      }
      // {
        path = lib.mkOption {
          type = lib.types.path;
          description = "The path of the file to put the secret in";
          example = "samba/credentials";
        };
        reference = lib.mkOption {
          type = lib.types.path;
          description = "The reference to the secret to put in the file";
          example = "n";
        };
      };
  };

  config = {
    services.onepassword-secrets = {
      enable = config.opnix.secrets != [];
      users = ["rose" "aubrey"];
      tokenFile =
        if isDesktop
        then "/etc/opnix-token"
        else "/var/opnix-token";
      configFile = builtins.toFile "config.json" (builtins.toJSON config.opnix);
    };

    systemd.services.onepassword-secrets = {
      requires = ["network-online.target"];
      after = ["network-online.service"];
    };
  };
}
