{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.networking.startupOnlineCheckUrls = lib.mkOption {
    type = lib.types.listOf lib.types.str;
  };

  config = {
    networking.startupOnlineCheckUrls = [
      "https://example.com"
      "https://github.com/NixOS/nixpkgs"
    ];
    systemd.services.network-connected = {
      description = "Startup network connection tester";
      wantedBy = [ "network-online.target" ];
      after = [ "network.target" ];
      script =
        let
          urls = lib.strings.concatStringsSep " " (
            map (value: "\"${value}\"") config.networking.startupOnlineCheckUrls
          );
        in
        ''
          array=(${urls})
          for var in "''${array[@]}"
          do
            echo 'checking' $var
            until ${pkgs.curl}/bin/curl --output /dev/null --silent --head --fail $var; do
              printf '.'
              sleep 5
            done
            echo
          done
        '';
      serviceConfig = {
        Type = "oneshot";
      };
    };
  };
}
