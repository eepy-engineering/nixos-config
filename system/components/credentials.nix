{
  isDesktop,
  config,
  lib,
  pkgs,
  ...
}: {
  options.opnix = {
    users = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default =
        if config.boot.isContainer
        then ["aubrey" "rose"]
        else [];
      description = "Users that should have access to the 1Password token through group membership";
      example = ["alice" "bob"];
    };

    outputDir = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/opnix/secrets";
      description = "Directory to store retrieved secrets";
    };

    secrets = lib.mkOption {
      default = [];
      type = lib.types.listOf (lib.types.submodule ({config, ...}: {
        options = {
          path = lib.mkOption {
            type = lib.types.str;
            description = "The path of the file to put the secret in";
            example = "samba/credentials";
          };
          reference = lib.mkOption {
            type = lib.types.str;
            description = "The reference to the secret to put in the file";
            example = "op://Services/SMB Login/password";
          };
        };
      }));
    };

    services = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "Services that depend on 1Password secrets to start";
    };
  };

  config = let
    cfg = config.opnix;
    opnixGroup = "onepassword-secrets";
    tokenFile =
      if isDesktop
      then "/etc/opnix-token"
      else "/var/opnix-token";
    configFile = builtins.toFile "config.json" (builtins.toJSON config.opnix);
    service = lib.mkIf (cfg.secrets != []) {
      description = "Prepare secrets from 1Password Service Vault";
      after = ["network-online.target"];
      wants = ["network-online.target"];
      wantedBy = cfg.services;
      before = cfg.services;
      serviceConfig = {
        Type = "oneshot";
      };
      script = ''
        # Ensure output directory exists with correct permissions
        mkdir -p ${cfg.outputDir}
        chmod 750 ${cfg.outputDir}

        # Set up token file with correct group permissions if it exists and is writable
        if [ -f ${tokenFile} ] && [ -w ${tokenFile} ]; then
          # Ensure token file has correct ownership and permissions
          chown root:${opnixGroup} ${tokenFile}
          chmod 640 ${tokenFile}
        fi

        # Validate token file existence and permissions
        if [ ! -f ${tokenFile} ]; then
          echo "Error: Token file ${tokenFile} does not exist!" >&2
          exit 1
        fi

        if [ ! -r ${tokenFile} ]; then
          echo "Error: Token file ${tokenFile} is not readable!" >&2
          exit 1
        fi

        # Validate token is not empty
        if [ ! -s ${tokenFile} ]; then
          echo "Error: Token file is empty!" >&2
          exit 1
        fi

        # Run the secrets retrieval tool
        ${pkgs.opnix}/bin/opnix secret \
          -token-file ${tokenFile} \
          -config ${configFile} \
          -output ${cfg.outputDir}
      '';
    };
  in {
    nixpkgs.overlays = [
      (final: prev: {
        asOpnixPath = path: "${cfg.outputDir}/${path}";
      })
    ];

    users = {
      groups.${opnixGroup} = {};
      users =
        lib.mkMerge (map (user: {"${user}".extraGroups = [opnixGroup];}) cfg.users);
    };

    systemd.services.onepassword-secrets = service;
    boot.initrd.systemd.services.onepassword-secrets = service;
  };
}
