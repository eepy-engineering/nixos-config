{
  pkgs,
  ...
}:
{
  imports = [
    ./dotnet.nix
    ./dolphin.nix
    ./flatpak.nix
    ./fpga.nix
    ./js.nix
    ./manpages.nix
    ./nix.nix
    ./ntp.nix
    ./obs.nix
    ./ppd.nix
    ./programming.nix
    ./qemu.nix
    ./steam.nix
    ./wireshark.nix
  ];
  environment.systemPackages = with pkgs; [
    lua51Packages.lua
    lua51Packages.luarocks
    pnpm
    nodejs

    #
    fusee-nano
    miniserve
    rsync
    cloudflared

    gdb

    tea
    gh
    kubectl
  ];

  # doesn't deserve its own file
  programs.zoom-us.enable = true;
}
