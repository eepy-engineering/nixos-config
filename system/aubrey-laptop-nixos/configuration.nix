{
  pkgs,
  inputs,
  lib,
  config,
  ...
}: {
  imports = [
    ./backups.nix
    ./desktop.nix
    ./hardware-configuration.nix
    ./networking.nix
    ./packages.nix
    ./wireless.nix
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
  services.power-profiles-daemon.enable = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  users.users = {
    walter.enable = false;
    rose.enable = false;
  };
  home-manager.users = lib.mkForce {
    aubrey = ../../user/aubrey;
  };

  time.timeZone = "America/Regina";

  services.logind.settings.Login.HandlePowerKey = "suspend";

  security.sudo.wheelNeedsPassword = false;

  programs.virt-manager.enable = true;
  virtualisation = {
    spiceUSBRedirection.enable = true;
    libvirtd = {
      enable = true;

      qemu = {
        runAsRoot = true;
        swtpm.enable = true;
        ovmf = {
          enable = true;
          packages = [pkgs.OVMFFull.fd];
        };
        vhostUserPackages = with pkgs; [virtiofsd];
      };
    };

    docker = {
      enable = true;
    };
  };

  boot.extraModulePackages = [
    config.boot.kernelPackages.gcadapter-oc-kmod
  ];

  # to autoload at boot:
  boot.kernelModules = [
    "gcadapter_oc"
  ];
  services.udev = {
    extraRules = ''
      # nintendo switch in rcm
      SUBSYSTEM=="usb", ATTR{idVendor}=="0955", MODE="0664", GROUP="plugdev"
      # bluetooth hci for dolphin
      SUBSYSTEM=="usb", ATTRS{idVendor}=="0e8d", ATTRS{idProduct}=="e616", TAG+="uaccess"
    '';
    packages = [
      pkgs.dolphin-emu
      (pkgs.stdenv.mkDerivation {
        name = "openfpgaloader-udev";
        src = pkgs.openfpgaloader.src;

        buildPhase = ''
          mkdir -p $out/etc/udev/rules.d
          ln -s $src/99-openfpgaloader.rules $out/etc/udev/rules.d
        '';
      })
    ];
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
    qemu = {
      target = "qemu/package";
      source = config.virtualisation.libvirtd.qemu.package;
    };
    virtiofsd = {
      target = "qemu/virtiofsd-package";
      source = pkgs.virtiofsd;
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
