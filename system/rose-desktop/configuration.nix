{
  config,
  pkgs,
  lib,
  ...
}:
{
  networking.hostName = "rose-desktop";

  imports = [
    ./hardware.nix
    ../components/nvidia-oss.nix
    ../components/bluetooth.nix
    ../components/rust.nix
    ../components/tank-share.nix
  ];

  tank-mount = {
    enable = true;
    username = "rose";
    opnix-login-references = {
      username = "op://Services/Rose - Nas SMB/username";
      password = "op://Services/Rose - Nas SMB/password";
    };
  };

  services = {
    xserver = {
      enable = true;

      windowManager.i3 = {
        enable = true;
        package = pkgs.i3-rounded;
        extraPackages = with pkgs; [
          dmenu
          feh
          i3status
          picom
          rofi
        ];
      };
    };

    displayManager.sddm = {
      enable = true;

      wayland = {
        enable = true;
        compositor = "weston";
      };
    };
  };

  programs = {
    steam = {
      enable = true;
    };
  };

  virtualisation.docker = {
    enable = true;
  };

  boot.kernelPackages = pkgs.linuxPackages_zen;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices."luks-3718c23c-bac8-4a77-8011-38132e0c8673".device =
    "/dev/disk/by-uuid/3718c23c-bac8-4a77-8011-38132e0c8673";
  networking.networkmanager.enable = true;
  time.timeZone = "America/New_York";
}
