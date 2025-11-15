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
  ];
}
