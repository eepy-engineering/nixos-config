{ pkgs, ... }:
{
  services.gpg-agent = {
    enable = true;
    pinentry.package = pkgs.pinentry-gtk2;
    defaultCacheTtl = 120;
    maxCacheTtl = 120;
  };

  home.packages = with pkgs; [
    gnupg
    pinentry-gtk2
  ];
}
