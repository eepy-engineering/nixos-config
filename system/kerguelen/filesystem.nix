{

  fileSystems."/" = {
    device = "tmpfs";
    fsType = "tmpfs";
  };

  fileSystems."/persist" = {
    device = "/dev/disk/by-uuid/15ea7064-494a-4d56-b4f8-6897054f7fa3";
    fsType = "btrfs";
    options = [
      "compress=zstd"
      "subvol=persist"
    ];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/15ea7064-494a-4d56-b4f8-6897054f7fa3";
    fsType = "btrfs";
    options = [
      "compress=zstd"
      "noatime"
      "subvol=nix"
    ];
  };

  fileSystems."/swap" = {
    device = "/dev/disk/by-uuid/15ea7064-494a-4d56-b4f8-6897054f7fa3";
    fsType = "btrfs";
    options = [ "subvol=swap" ];
  };

  swapDevices = [ { device = "/swap/swap.mem"; } ];
}
