{
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/bc150328-fa6d-4b25-b6c5-a31d22881a55";
    fsType = "btrfs";
    options = [ "subvol=root" ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/6B14-24A1";
    fsType = "vfat";
    options = [
      "fmask=0022"
      "dmask=0022"
    ];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/bc150328-fa6d-4b25-b6c5-a31d22881a55";
    fsType = "btrfs";
    options = [ "subvol=nix" ];
  };

  fileSystems."/persist" = {
    device = "/dev/disk/by-uuid/bc150328-fa6d-4b25-b6c5-a31d22881a55";
    fsType = "btrfs";
    options = [ "subvol=persist" ];
  };

  fileSystems."/var/log" = {
    device = "/dev/disk/by-uuid/bc150328-fa6d-4b25-b6c5-a31d22881a55";
    fsType = "btrfs";
    options = [ "subvol=log" ];
    neededForBoot = true;
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/bc150328-fa6d-4b25-b6c5-a31d22881a55";
    fsType = "btrfs";
    options = [ "subvol=home" ];
  };

  swapDevices = [
    { device = "/dev/disk/by-partuuid/59a35976-97d0-453e-966e-9ae6d3caab54"; }
  ];

  imports = [
    ../components/tank-share.nix
  ];

  tank-mount = {
    enable = true;
    username = "aubrey";
    group = "users";
    opnix-login-references = {
      username = "op://Services/Aubrey - Nas SMB/username";
      password = "op://Services/Aubrey - Nas SMB/password";
    };
  };
}
