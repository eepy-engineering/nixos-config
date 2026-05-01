pkgs: rec {
  ilo-sitelen = pkgs.callPackage ./ilo-sitelen.nix { };
  swim-unstable = pkgs.callPackage ./swim.nix { };
  surfer-unstable = pkgs.callPackage ./surfer.nix { };
  gamemaker = pkgs.callPackage ./gamemaker.nix {
    gamemakerFlavor = "Beta";
    gamemakerVersion = "2024.1400.2.941";
    gamemakerHash = "sha256-Mng4iwbrGWKj7wl5+yCv/S3LEi+bYPGiCkEaqq9htIQ=";
  };
  gamemakerEnv =
    let
      libPath =
        with pkgs;
        pkgs.lib.makeLibraryPath [
          libGL
          libdrm
          libgbm
          udev
          libudev0-shim
          libva
          libxkbcommon
          wayland
          bzip2
          libpng
          brotli
          vulkan-tools
          vulkan-loader
          dotnetCorePackages.dotnet_8.vmr
        ];
      gmRunner = pkgs.writeNushellScriptBin "gamemaker-studio" ''
        def --wrapped main [...args] {
          ${gamemaker}/opt/GameMaker-Beta/GameMaker ...$args
        }
      '';
    in
    pkgs.buildFHSEnv {
      name = "gamemaker-studio";
      targetPkgs =
        pkgs: with pkgs; [
          gamemaker
          gmRunner
          openssl
          freetype

          SDL2
          fna3d
          mesa-demos
          gtk3
          libGL
          libdrm
          libgbm
          udev
          libudev0-shim
          libva
          vulkan-headers
          vulkan-loader
          vulkan-tools
          libz
          bzip2

          dotnetCorePackages.dotnet_8.sdk
          dotnetCorePackages.dotnet_8.vmr
        ];
      profile = ''
        export LD_LIBRARY_PATH=${libPath}
        export DOTNET_BIN=${pkgs.dotnetCorePackages.dotnet_8.sdk}/bin/dotnet
        export TMPDIR=
      '';
      # runScript = with pkgs; "bash";
      runScript = with pkgs; "bash -c 'steam-run ${gamemaker}/opt/GameMaker-Beta/GameMaker'";
    };
}
