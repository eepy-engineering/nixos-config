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
  services.power-profiles-daemon.enable = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "aubrey-laptop-nixos";
  networking.nameservers = [
    "1.1.1.1"
    "1.0.0.1"
  ];
  services.resolved = {
    enable = true;
    dnssec = "true";
    domains = ["~."];
    fallbackDns = [
      "1.1.1.1"
      "1.0.0.1"
    ];
    dnsovertls = "true";
  };
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
  services.udev.packages = [pkgs.dolphin-emu];

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
    seat2 = {
      target = "udev/rules.d/52-dolphin.rules";
      text = ''
        SUBSYSTEM=="usb", ATTRS{idVendor}=="0e8d", ATTRS{idProduct}=="e616", TAG+="uaccess"
      '';
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
    package = pkgs.obs-studio.overrideAttrs (oldAttrs: {
      src = pkgs.fetchFromGitHub {
        owner = "obsproject";
        repo = "obs-studio";
        rev = "12c6febae21f369da50f09d511b54eadc1dc1342"; # https://github.com/obsproject/obs-studio/pull/11906
        sha256 = "sha256-DIlAMCdve7wfbMV5YCd3qJnZ2xwJMmQD6LamGP7ECOA=";
        fetchSubmodules = true;
      };
      version = "31.1.0-beta1";
      patches =
        builtins.filter (
          patch:
            !(
              builtins.baseNameOf (toString patch) == "Enable-file-access-and-universal-access-for-file-URL.patch"
            )
        )
        oldAttrs.patches;
    });
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
