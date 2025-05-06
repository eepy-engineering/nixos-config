{
  pkgs,
  inputs,
  lib,
  config,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./backups.nix
    ./packages.nix
    ../components/bluetooth.nix
    ../components/rust.nix
  ];

  boot.kernelPackages = pkgs.unstable.linuxPackages_zen;
  boot.supportedFilesystems = ["btrfs"];

  hardware.enableAllFirmware = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "aubrey-laptop-nixos";
  networking.networkmanager.enable = true;

  time.timeZone = "America/Regina";

  services.displayManager.sddm = {
    enable = true;
    wayland = {
      enable = true;
    };
  };
  services.desktopManager.plasma6.enable = true;

  services.printing.enable = true;
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };
  services.libinput.enable = true;

  security.sudo.wheelNeedsPassword = false;

  programs.virt-manager.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;
  virtualisation.libvirtd = {
    enable = true;
    qemu.vhostUserPackages = with pkgs; [virtiofsd];
  };

  environment.etc = {
    "1password/custom_allowed_browsers" = {
      text = ''
        zen
        zen-bin
        .zen-wrapped
        .zen-bin-wrapped
      '';
      mode = "0755";
    };
    seat = {
      target = "udev/rules.d/50-switch.rules";
      text = ''
        SUBSYSTEM=="usb", ATTR{idVendor}=="0955", MODE="0664", GROUP="plugdev"
      '';
    };
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  programs.wireshark = {
    enable = true;
    package = pkgs.wireshark-qt;
  };
  services.tailscale.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  home-manager.backupFileExtension = "hmbak";
}
