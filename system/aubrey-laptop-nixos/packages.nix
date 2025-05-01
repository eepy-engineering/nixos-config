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
    unstable.dotnetCorePackages.dotnet_9.sdk

    # cli tools
    nixos-rebuild
    unzip
    ripgrep
    wget
    git
    direnv
    killall
    neofetch
    nmap
    fusee-nano
    miniserve
    libfaketime
    rclone
    rsync
    binwalk
    file
    dig
    gdb
    binutils
    tea
    gh
    opnix

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
