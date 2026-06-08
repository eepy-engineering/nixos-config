{
  pkgs,
  ...
}:
{
  imports = [
    ./dotnet.nix
    ./fpga.nix
    ./js.nix
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
}
