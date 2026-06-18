{ pkgs, ... }: {

  boot = {
    kernelPackages = pkgs.linuxPackages_zen;
    supportedFilesystems = [ "btrfs" ];

    kernelModules = [ "kvm-amd" ];
    extraModulePackages = [ ];

    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 16;
      };
      efi.canTouchEfiVariables = true;
    };

    initrd = {
      availableKernelModules = [
        "nvme"
        "xhci_pci"
        "thunderbolt"
        "usbhid"
        "usb_storage"
        "sd_mod"
      ];
      kernelModules = [ "amdgpu" ];
      network.enable = true;
      systemd = {
        enable = true;
        network = {
          enable = true;
          wait-online.extraArgs = [ "--dns" ];
        };
      };
    };
  };
}
