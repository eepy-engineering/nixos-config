{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # language frameworks
    clang
    llvmPackages_19.clang-unwrapped
    python3
    lua51Packages.lua
    lua51Packages.luarocks
    pnpm
    nodejs
    jdk23
    dotnetCorePackages.dotnet_9.sdk

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

    # dependencies
    OVMFFull

    # gui
    mako
    shutter
    libreoffice-still
    remmina
    vlc
    obs-studio
    qpwgraph
  ];
}
