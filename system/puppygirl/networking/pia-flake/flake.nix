{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    pia-openvpn = {
      url = "https://www.privateinternetaccess.com/openvpn/openvpn.zip";
      flake = false;
    };
  };

  outputs =
    {
      flake-utils,
      nixpkgs,
      pia-openvpn,
      self,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        inherit (pkgs) lib;

        pkgs = import nixpkgs {
          inherit system;
        };
      in
      {
        packages = {
          pia = import ./cli.nix { inherit lib pkgs; };
          default = self.packages.${system}.pia;
        };

        apps = {
          default = self.apps.${system}.pia;

          pia = {
            type = "app";
            program = "${self.packages.${system}.pia}/bin/pia";

            meta = with pkgs.lib; {
              description = "Private Internet Access VPN CLI for NixOS";
              license = licenses.gpl3Only;
              maintainers = [ maintainers.Fuwn ];
              homepage = "https://github.com/Fuwn/pia.nix";
              mainPackage = "pia";
              platforms = platforms.linux;
            };
          };
        };

        nixosModules.default =
          { config, ... }:
          {
            options.services.pia =
              let
                inherit (lib) mkOption;
              in
              {
                enable = mkOption {
                  default = false;
                  type = lib.types.bool;
                };

                authUserPass = {
                  username = mkOption {
                    default = "";
                    type = lib.types.str;
                  };

                  password = mkOption {
                    default = "";
                    type = lib.types.str;
                  };
                };

                authUserPassFile = mkOption {
                  default = /dev/null;
                  type = lib.types.path;
                };
              };

            config = lib.mkIf config.services.pia.enable {
              environment.systemPackages = [
                self.packages.${system}.pia
              ];

              services.openvpn.servers = builtins.listToAttrs (
                map
                  (name: {
                    name =
                      (builtins.replaceStrings
                        [
                          ".ovpn"
                          "_"
                        ]
                        [
                          ""
                          "-"
                        ]
                      )
                        name;

                    value =
                      let
                        pia = config.services.pia;
                        hardcoded = pia.authUserPassFile == /dev/null;
                      in
                      {
                        authUserPass = if hardcoded then pia.authUserPass else null;
                        autoStart = false;
                        updateResolvConf = true;

                        config = ''
                          config ${pia-openvpn}/${name}
                          auth-nocache
                          ${if hardcoded then "" else "auth-user-pass ${pia.authUserPassFile}"}
                        '';
                      };
                  })
                  (
                    builtins.filter (name: (builtins.match ".+ovpn$" name) != null) (
                      builtins.attrNames (builtins.readDir pia-openvpn)
                    )
                  )
              );
            };
          };
      }
    );
}
