{
  imports = [
    ./hardware-configuration.nix
    ./kubernetes-master.nix
    ./kata.nix
    ./nginx.nix
    ./smb.nix
    ./vms
    ./zfs-notifs
    ./containers.nix
    ./databases.nix
    ./filesystems.nix
    ./hall-dns.nix
    ./immich.nix
    ./networking.nix
    ./torrent
    ./music.nix
    ./jellyfin.nix
    ./cloudflared.nix
    ./calendar.nix
    ./analytics
    ./calibre.nix
    ./syncplay.nix
    ../components/virtualization.nix

    ../configuration.nix
    ../../user/configuration.nix
  ];

  boot.loader = {
    grub = {
      enable = true;
      zfsSupport = true;
      efiSupport = true;
      efiInstallAsRemovable = false;
      mirroredBoots = [
        {
          devices = [ "nodev" ];
          path = "/boot";
        }
      ];
    };
    efi.canTouchEfiVariables = true;
  };

  time.timeZone = "America/New_York";

  boot.supportedFilesystems = [ "zfs" ];
  boot.initrd.supportedFilesystems = [ "zfs" ];
  boot.kernel.sysctl = {
    "fs.inotify.max_user_watches" = "2097152";
    "fs.inotify.max_user_instances" = "1024";
  };

  security.sudo.wheelNeedsPassword = false;

  programs.fuse = {
    enable = true;
    userAllowOther = true;
  };

  services.tailscale = {
    extraSetFlags = [ "--advertise-exit-node" ];
    useRoutingFeatures = "server";
  };

  # The router forwards UDP 41641 to kokuzo (a static port forward, added
  # 2026-10-28). Tell peers so, so that ones behind hard NATs (rclamp, on
  # RC's network) connect directly instead of through a DERP relay: the
  # router's own UPnP mapping only takes packets from addresses kokuzo has
  # already sent to. A tailscaled debug knob; the address is the Fios one
  # that hall-dns.nix keeps hall.ly pointed at, and goes stale if that
  # changes (peers then fall back to the relay).
  systemd.services.tailscaled.environment.TS_DEBUG_PRETENDPOINT = "108.30.87.159:41641";

  services.openssh = {
    hostKeys = [
      {
        type = "ed25519";
        path = "/persist/ssh-host-keys/ssh_host_ed25519_key";
      }
      {
        type = "rsa";
        bits = 4096;
        path = "/persist/ssh-host-keys/ssh_host_rsa_key";
      }
    ];
  };

  services.getty.autologinUser = "root";

  services.sanoid = {
    enable = true;
    datasets = {
      tank = {
        hourly = 24;
        daily = 30;
        autoprune = true;
        autosnap = true;
        # from the docs: atomic recursive snapshots, though child datasets
        # can't be configured independently
        recursive = "zfs";
      };
      "apps/smo-wiki" = {
        hourly = 24;
        daily = 30;
        autoprune = true;
        autosnap = true;
      };
      "apps/smo-wiki-mysql" = {
        hourly = 24;
        daily = 30;
        autoprune = true;
        autosnap = true;
      };
    };
  };
}
