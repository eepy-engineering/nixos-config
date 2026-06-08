{
  fileSystems = {
    "/" = {
      device = "tmpfs";
      fsType = "tmpfs";
      options = [ "mode=0755" ];
    };
    "/boot" = {
      device = "/dev/disk/by-partuuid/7594381a-8ef1-487b-b1ad-1ca83f128216";
      fsType = "vfat";
      options = [
        "fmask=0022"
        "dmask=0022"
      ];
      depends = [ "/" ];
    };
    "/persist" = {
      device = "/dev/disk/by-uuid/15ea7064-494a-4d56-b4f8-6897054f7fa3";
      fsType = "btrfs";
      options = [
        "compress=zstd"
        "subvol=persist"
      ];
      depends = [ "/" ];
    };
    "/nix" = {
      device = "/dev/disk/by-uuid/15ea7064-494a-4d56-b4f8-6897054f7fa3";
      fsType = "btrfs";
      options = [
        "compress=zstd"
        "noatime"
        "subvol=nix"
      ];
      depends = [ "/" ];
    };
    "/swap" = {
      device = "/dev/disk/by-uuid/15ea7064-494a-4d56-b4f8-6897054f7fa3";
      fsType = "btrfs";
      options = [ "subvol=swap" ];
      depends = [ "/" ];
    };
  };

  swapDevices = [ { device = "/swap/swap.mem"; } ];
}
