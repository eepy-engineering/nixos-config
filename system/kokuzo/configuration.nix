{
  imports = [
    ./hardware-configuration.nix
    ./kubernetes-master.nix
    ./nginx.nix
    ./smb.nix
    ./vms
    ./filesystems.nix
    ./hall-dns.nix
    ./networking.nix
    ./torrent
    ./music.nix
    ./jellyfin.nix
    ./cloudflared.nix
    ./calendar.nix
    ./analytics
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

  virtualisation.docker.enable = true;

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
    };
  };
}
