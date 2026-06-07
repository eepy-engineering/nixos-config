{
  config,
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    # language frameworks

    # cli tools
    libfaketime
    gdb
    dive
    everest-mons
    nix-index
    perf
    v4l-utils
    swtpm
    pkgs.android-tools

    # dependencies
    icu
    dnsmasq
    phodav
    config.virtualisation.libvirtd.qemu.package

    # gui
    shutter
    remmina
    vlc
    qpwgraph
    wpa_supplicant_gui
    dolphin-emu
    _010editor
    # archipelago
    # ((sm64ex.override { stdenv = gcc15Stdenv; }).overrideAttrs (orig: {
    #   src = fetchFromGitHub {
    #     owner = "N00byKing";
    #     repo = "sm64ex";
    #     rev = "fe187c151aa608361d30d1819edca131c0043cf9";
    #     hash = "sha256-7+tp/2zhtaxtgzL6I8vQLRWyGIxsnrd+R9opcUhCObc=";
    #     fetchSubmodules = true;
    #   };
    #   dontUseCmakeConfigure = true;
    #   nativeBuildInputs = orig.nativeBuildInputs ++ [
    #     cmake
    #   ];
    #   installPhase = ''
    #     runHook preInstall

    #     mkdir -p $out/bin $out/lib
    #     cp build/us_pc/sm64.us.f3dex2e $out/bin/sm64ex
    #     cp build/us_pc/libAPCpp.so $out/lib/

    #     runHook postInstall
    #   '';
    # }))
  ];

  services.flatpak.enable = true;
}
