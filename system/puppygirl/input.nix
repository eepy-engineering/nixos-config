{
  services.udev = {
    extraRules = ''
      # nintendo switch in rcm
      SUBSYSTEM=="usb", ATTR{idVendor}=="0955", MODE="0664", GROUP="plugdev"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="2341", MODE:="0664", GROUP="plugdev"
      ACTION=="add", SUBSYSTEM=="pci", DRIVER=="pcieport", ATTR{power/wakeup}="disabled"
      SUBSYSTEM=="usb", MODE="0660", GROUP="plugdev"
    '';
  };

  hardware.opentabletdriver = {
    enable = true;
  };
  services = {
    libinput.enable = true;
  };
}
