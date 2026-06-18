{ config, pkgs, ... }: {
  services.udev = {
    extraRules = ''
      # bluetooth hci for dolphin
      SUBSYSTEM=="usb", ATTRS{idVendor}=="0e8d", ATTRS{idProduct}=="e616", TAG+="uaccess"
    '';
    packages = [
      pkgs.dolphin-emu
    ];
  };

  boot.extraModulePackages = [
    config.boot.kernelPackages.gcadapter-oc-kmod
  ];

  # to autoload at boot:
  boot.kernelModules = [
    "gcadapter_oc"
  ];

}
