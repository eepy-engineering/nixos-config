{
  config,
  pkgs,
  lib,
  ...
}: {
  options.networking.wireless.secrets = lib.mkOption {
    default = {};
    type = lib.types.attrsOf lib.types.str;
  };

  config = let
    secrets = config.networking.wireless.secrets;
    secretToOpnix = secretName: {
      path = "wirelessCredentials/${secretName}";
      reference = builtins.getAttr secretName secrets;
    };
  in
    lib.mkIf (builtins.length (builtins.attrNames secrets) > 0) {
      opnix = {
        secrets = map secretToOpnix (builtins.attrNames secrets);
        services = ["wireless-credentials.service"];
      };

      systemd.services.wireless-credentials = {
        description = "Prepare secrets from 1Password Service Vault";
        wantedBy = ["wpa_supplicant.service"];
        serviceConfig = {
          Type = "oneshot";
        };
        script = let
          secretStrings = lib.strings.concatStringsSep " " (map (secretName: "{name: \"${secretName}\", secret: ${pkgs.asOpnixPath "wirelessCredentials/${secretName}"}}") (builtins.attrNames secrets));
        in ''
          ${pkgs.writeNushellScript "wireless-env.nu" ''
            def main [] {
              let args = [${secretStrings}];
              let psks = $args | each {|network| $"($network.name)=(open $network.secret -r)"} | str join "\n";
              $psks | save -f ${pkgs.asOpnixPath "wirelessCredentials/secretFile"}
            }
          ''}
        '';
      };

      networking.wireless = {
        secretsFile = pkgs.asOpnixPath "wirelessCredentials/secretFile";
      };
    };
}
