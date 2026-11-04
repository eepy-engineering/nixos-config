{
  pkgs,
  lib,
  isDesktop,
  ...
}:
{
  home.packages = lib.mkIf isDesktop [
    pkgs.keepassxc
  ];
}
