{
  description = "Rose's NixOS Configuration";

  inputs = {
    # Use the unstable NixPkgs branch
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # Use community VSCode extensions
    extensions.url = "github:nix-community/nix-vscode-extensions";
    extensions.inputs.nixpkgs.follows = "nixpkgs";

    # Use home-manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Use OpNix for secrets
    opnix.url = "github:Sanae6/opnix";
    opnix.inputs.nixpkgs.follows = "nixpkgs";

    # Applications
    zen-browser.url = "github:youwen5/zen-browser-flake";
    zen-browser.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs @ {
    nixpkgs,
    home-manager,
    opnix,
    extensions,
    zen-browser,
    ...
  }: let
    lib = nixpkgs.lib;
    overlays = [
      extensions.overlays.default
      (final: _prev: {
        opnix = opnix.packages.${final.system}.default;
        zen-browser = zen-browser.packages.${final.system}.default;
        unstable = import inputs.nixpkgs-unstable {
          system = final.system;
          config.allowUnfree = true;
        };
        home-manager = home-manager.packages.${final.system};
      })
    ];
    overlaysModule = _: {nixpkgs.overlays = overlays;};
    configs = {
      rose-desktop = {
        # rose's desktop
        isDesktop = true;
        system = "x86_64-linux";
      };
      aubrey-laptop-nixos = {
        # aubrey's laptop
        isDesktop = true;
        system = "x86_64-linux";
      };
      kokuzo = {
        # nas
        isDesktop = false;
        system = "x86_64-linux";
      };
    };
    hmUsers = ["aubrey" "rose"];
  in {
    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.alejandra;
    home-manager.backupFileExtension = "backup";

    nixosConfigurations = let
      buildConfig = name: config:
        lib.nixosSystem {
          system = config.system;
          specialArgs = {
            inherit inputs opnix;
            isDesktop = config.isDesktop;
          };
          modules = [
            overlaysModule
            opnix.nixosModules.default
            home-manager.nixosModules.home-manager
            ./system/configuration.nix
            ./system/${name}/configuration.nix
            ./user/configuration.nix
          ];
        };
    in
      builtins.mapAttrs buildConfig configs;

    homeConfigurations = let
      buildConfig = username: config:
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            system = config.system;
            inherit overlays;

            config = {
              allowUnfree = true;
              allowInsecurePredicate = pkg: true;
            };
          };
          extraSpecialArgs = {
            inherit inputs opnix;
            isDesktop = config.isDesktop;
          };
          modules = [
            overlaysModule
            ./user/${username}
          ];
        };
      configPairs = lib.attrsets.mapAttrsToList lib.attrsets.nameValuePair configs;
      buildConfigs = lib.lists.flatten (map (username: map (config: {"${username}@${config.name}" = buildConfig username config.value;}) configPairs) hmUsers);
    in
      lib.attrsets.mergeAttrsList buildConfigs;
  };
}
