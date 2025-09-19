{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = [
    "nvme"
    "thunderbolt"
    "xhci_pci"
    "ahci"
    "usbhid"
    "usb_storage"
    "sd_mod"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/2d3ae16a-d990-4b39-9bdf-61cbfdc4795f";
    fsType = "ext4";
  };

  boot.initrd.luks.devices."luks-62599034-561d-4238-988e-7febf20626e7".device =
    "/dev/disk/by-uuid/62599034-561d-4238-988e-7febf20626e7";

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/2E09-10AB";
    fsType = "vfat";
    options = [
      "fmask=0077"
      "dmask=0077"
    ];
  };

  swapDevices = [
    { device = "/dev/disk/by-uuid/689ce87c-47e8-4530-8718-8ef669586393"; }
  ];

  networking.interfaces.eno1.useDHCP = true;
  networking.interfaces.eno2.useDHCP = true;
  networking.interfaces.wlp9s0.useDHCP = true;

  nixpkgs.hostPlatform = "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = config.hardware.enableRedistributableFirmware;
}
