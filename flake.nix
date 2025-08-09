{
  description = "Rose and Aubrey's NixOS Configuration";

  inputs = {
    # Use the unstable NixPkgs branch
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

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
    nix-index.url = "github:nix-community/nix-index";
    nix-index.inputs.nixpkgs.follows = "nixpkgs";
    nu-scripts = {
      url = "github:nushell/nu_scripts";
      flake = false;
    };
    surfer = {
      url = "git+https://gitlab.com/surfer-project/surfer.git/?submodules=1";
      flake = false;
    };
    swim = {
      url = "git+https://gitlab.com/spade-lang/swim.git/?submodules=1";
      flake = false;
    };

    # Fenix (Rust)
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Microvm
    microvm = {
      url = "github:astro/microvm.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nixGL
    nixGL = {
      url = "github:nix-community/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Neovim Plugins
    spade-nvim = {
      url = "github:ethanuppal/spade.nvim";
      flake = false;
    };
  };

  outputs = inputs @ {
    nixpkgs,
    home-manager,
    opnix,
    extensions,
    zen-browser,
    nix-index,
    fenix,
    microvm,
    nixGL,
    ...
  }: let
    lib = nixpkgs.lib;
    overlays =
      [
        extensions.overlays.default
        fenix.overlays.default
        nixGL.overlay
        (final: prev:
          {
            inherit inputs;
            opnix = opnix.packages.${final.system}.default;
            zen-browser = zen-browser.packages.${final.system}.default;
            nix-index = nix-index.packages.${final.system}.default;
            home-manager = home-manager.packages.${final.system};
          }
          // (import ./packages prev))
      ]
      ++ import ./overlays;
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
      compute = {
        # compute
        isDesktop = false;
        system = "x86_64-linux";
      };
    };
    hmUsers = ["aubrey" "rose"];
  in {
    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.alejandra;

    packages.x86_64-linux = import ./packages (import nixpkgs {
      system = "x86_64-linux";

      overlays = overlays;
      specialArgs = {
        inherit inputs;
      };

      config = {
        allowUnfree = true;
        allowInsecurePredicate = pkg: true;
      };
    });

    nixosConfigurations = let
      buildConfig = name: config:
        lib.nixosSystem {
          system = config.system;
          specialArgs = {
            inherit inputs opnix microvm;
            isDesktop = config.isDesktop;
          };
          modules = [
            overlaysModule
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
