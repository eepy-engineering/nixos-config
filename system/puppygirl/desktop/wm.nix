{ pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.sway
  ];

  programs.hyprland.enable = true;
  security.pam.services.swaylock = { };
}
