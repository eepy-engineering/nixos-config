pkgs: rec {
  gamemaker = pkgs.callPackage ./gamemaker.nix {
    gamemakerFlavor = "Beta";
    gamemakerVersion = "2024.1400.0.815";
    gamemakerHash = "sha256-tMpVdlk9J6/nQHAVX8xUN2+RF4rloxSDuvWtMJmYQlM=";
  };
  gamemakerEnv = let
    libPath = with pkgs;
      pkgs.lib.makeLibraryPath [
        libGL
        libdrm
        libgbm
        udev
        libudev0-shim
        libva
        libxkbcommon
        wayland
      ];
    gmRunner = pkgs.writeNushellScriptBin "gamemaker-studio" ''
      def --wrapped main [...args] {
        ${gamemaker}/opt/GameMaker-Beta/GameMaker ...$args
      }
    '';
  in
    pkgs.buildFHSEnv {
      name = "gamemaker-env";
      targetPkgs = pkgs:
        with pkgs; [
          gamemaker
          gmRunner
          openssl
          freetype

          SDL2
          fna3d
          glxinfo
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
        ];
      profile = ''
        export LD_LIBRARY_PATH=${libPath}
      '';
      runScript = with pkgs; "bash";
      # runScript = with pkgs; "${gamemaker}/opt/GameMaker-Beta/GameMaker";
    };
}
