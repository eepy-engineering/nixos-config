{
  description = "Rose and Aubrey's NixOS Configuration";

  inputs = {
    # Use the unstable NixPkgs branch
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Use community VSCode extensions
    extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Use home-manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # add tetra's user
    tetra-config = {
      url = "github:tetraxile/nixos-config";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    # Use OpNix for secrets
    opnix = {
      url = "github:Sanae6/opnix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Applications
    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index = {
      url = "github:nix-community/nix-index";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
    O10editor = {
      url = "github:Sanae6/010editor-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Fenix (Rust)
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Microvm
    microvm = {
      url = "github:microvm-nix/microvm.nix";
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

    catppuccin.url = "github:catppuccin/nix";
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
    O10editor,
    catppuccin,
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
            _010editor = O10editor.packages.${final.system}.default;
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
      puppygirl = {
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
    inherit inputs;

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
