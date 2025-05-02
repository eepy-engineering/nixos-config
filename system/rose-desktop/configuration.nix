{
  config,
  pkgs,
  lib,
  ...
}: {
  networking.hostName = "rose-desktop";

  imports = [
    ./hardware.nix
    ../components/nvidia-oss.nix
  ];

  services = {
    xserver = {
      enable = true;

      windowManager.i3 = {
        enable = true;
        extraPackages = with pkgs; [
          dmenu
          feh
          i3status
          picom
          rofi
        ];
      };
    };

    desktopManager.plasma6.enable = true;
    displayManager = {
      defaultSession = "plasmax11";
      sddm.enable = true;
    };
  };

  systemd.user.services.plasma-i3wm = {
    wantedBy = ["plasma-workspace-x11.target"];
    description = "Launch Plasma with i3wm.";
    environment = lib.mkForce {};
    serviceConfig = {
      ExecStart = "${pkgs.i3}/bin/i3";
      Restart = "on-failure";
    };
  };
  systemd.user.services.plasma-workspace-x11.after = ["plasma-i3wm.target"];
  systemd.user.services.plasma-kwin_x11.enable = false;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices."luks-3718c23c-bac8-4a77-8011-38132e0c8673".device = "/dev/disk/by-uuid/3718c23c-bac8-4a77-8011-38132e0c8673";
  networking.networkmanager.enable = true;
  time.timeZone = "America/New_York";
}
