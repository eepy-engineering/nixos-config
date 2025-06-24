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
    ../components/tank-share.nix
  ];

  boot.kernelPackages = pkgs.linuxPackages_zen;
  boot.supportedFilesystems = ["btrfs"];

  boot.initrd.network.enable = true;
  boot.initrd.systemd = {
    enable = true;
    network = {
      enable = true;
      wait-online.extraArgs = ["--dns"];
    };
  };

  hardware.enableAllFirmware = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "aubrey-laptop-nixos";
  networking.networkmanager.enable = false;

  networking.wireless = {
    enable = true;
    userControlled.enable = true;

    secrets = {
      homePsk = "op://Services/tfohn2xlz72a75pmhl3k26wcou/password";
    };
    networks = {
      "Private Network".pskRaw = "ext:homePsk";
    };
  };

  users.users = {
    walter.enable = false;
  };

  time.timeZone = "America/Regina";

  services.logind.powerKey = "suspend";

  services.displayManager.sddm = {
    enable = true;
    wayland = {
      enable = true;
    };
  };
  services.desktopManager.plasma6.enable = false;

  xdg = {
    mime.enable = true;
    portal = {
      enable = true;
      wlr.enable = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-gtk
      ];
    };
  };

  services.printing.enable = true;
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };
  services.libinput.enable = true;

  security.sudo.wheelNeedsPassword = false;

  programs.virt-manager.enable = true;
  virtualisation = {
    spiceUSBRedirection.enable = true;
    libvirtd = {
      enable = true;
      qemu.vhostUserPackages = with pkgs; [virtiofsd];
    };
    docker = {
      enable = true;
    };
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

  tank-mount = {
    enable = true;
    username = "aubrey";
    opnix-login-references = {
      username = "op://Services/Aubrey - Nas SMB/username";
      password = "op://Services/Aubrey - Nas SMB/password";
    };
  };

  programs.sway.enable = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };
  programs.obs-studio = {
    enable = true;
    enableVirtualCamera = true;
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-backgroundremoval
      obs-pipewire-audio-capture
      obs-vaapi #optional AMD hardware acceleration
      obs-gstreamer
      obs-vkcapture
    ];
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
