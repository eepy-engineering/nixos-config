{
  description = "Rose's NixOS Configuration";

  inputs = {
    # Use the unstable NixPkgs branch
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Use home-manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs @ {
    nixpkgs,
    home-manager,
    ...
  }: {
    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.alejandra;

    nixosConfigurations = {
      rose-desktop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          home-manager.nixosModules.home-manager
          ./system/configuration.nix
          ./system/rose-desktop/configuration.nix
          ./user/configuration.nix
        ];
      };
    };
  };
}
