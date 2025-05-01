{
  description = "Rose's NixOS Configuration";

  inputs = {
    # Use the unstable NixPkgs branch
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # Use community VSCode extensions
    extensions.url = "github:nix-community/nix-vscode-extensions";
    extensions.inputs.nixpkgs.follows = "nixpkgs";

    # Use home-manager
    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Use OpNix for secrets
    opnix.url = "github:brizzbuzz/opnix";
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
  }: {
    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.alejandra;

    nixosConfigurations = let
      overlays = [
        extensions.overlays.default
        (final: _prev: {
          opnix = opnix.packages.${final.system}.default;
          zen-browser = zen-browser.packages.${final.system}.default;
          unstable = import inputs.nixpkgs-unstable {
            system = final.system;
            config.allowUnfree = true;
          };
        })
      ];
      overlaysModule = _: {nixpkgs.overlays = overlays;};
    in {
      rose-desktop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs opnix;
          isDesktop = true;
        };
        modules = [
          overlaysModule
          opnix.nixosModules.default
          home-manager.nixosModules.home-manager
          ./system/configuration.nix
          ./system/rose-desktop/configuration.nix
          ./user/configuration.nix
        ];
      };
      aubrey-laptop-nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs opnix;
          isDesktop = true;
        };
        modules = [
          overlaysModule
          opnix.nixosModules.default
          home-manager.nixosModules.home-manager
          ./system/configuration.nix
          ./system/aubrey-laptop-nixos/configuration.nix
          ./user/configuration.nix
        ];
      };
    };
  };
}
