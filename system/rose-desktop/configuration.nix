{
  config,
  pkgs,
  ...
}: {
  networking.hostName = "rose-desktop";

  imports = [
    ./hardware.nix
    ../components/nvidia-oss.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices."luks-3718c23c-bac8-4a77-8011-38132e0c8673".device = "/dev/disk/by-uuid/3718c23c-bac8-4a77-8011-38132e0c8673";
  networking.networkmanager.enable = true;
  time.timeZone = "America/New_York";
}
