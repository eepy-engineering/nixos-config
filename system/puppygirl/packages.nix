{
  config,
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    # language frameworks
    clang
    llvmPackages_19.clang-unwrapped
    python3
    lua51Packages.lua
    lua51Packages.luarocks
    pnpm
    nodejs
    (dotnetCorePackages.combinePackages [
      dotnet-sdk_6
      dotnet-runtime_6
      dotnet-sdk_8
      dotnet-sdk_9
    ])
    # dotnet-sdk_10

    # cli tools
    fusee-nano
    miniserve
    libfaketime
    rsync
    gdb
    tea
    gh
    kubectl
    cloudflared
    dive
    everest-mons
    nix-index
    config.boot.kernelPackages.perf
    v4l-utils
    swtpm
    openfpgaloader

    # dependencies
    icu
    dnsmasq
    phodav
    config.virtualisation.libvirtd.qemu.package

    # gui
    mako
    shutter
    libreoffice-still
    remmina
    vlc
    qpwgraph
    wpa_supplicant_gui
    dolphin-emu
    _010editor
    archipelago
    ((sm64ex.override { stdenv = gcc15Stdenv; }).overrideAttrs (orig: {
      src = fetchFromGitHub {
        owner = "N00byKing";
        repo = "sm64ex";
        rev = "fe187c151aa608361d30d1819edca131c0043cf9";
        hash = "sha256-7+tp/2zhtaxtgzL6I8vQLRWyGIxsnrd+R9opcUhCObc=";
        fetchSubmodules = true;
      };
      dontUseCmakeConfigure = true;
      nativeBuildInputs = orig.nativeBuildInputs ++ [
        cmake
      ];
      installPhase = ''
        runHook preInstall

        mkdir -p $out/bin $out/lib
        cp build/us_pc/sm64.us.f3dex2e $out/bin/sm64ex
        cp build/us_pc/libAPCpp.so $out/lib/

        runHook postInstall
      '';
    }))
  ];
}
