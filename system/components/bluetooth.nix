{
  pkgs,
  lib,
  ...
}:
{
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  services.blueman.enable = true;
  users.groups.bluetooth = { };
  # Group with the permission to edit bluetooth devices

  services.dbus.packages = lib.mkAfter [
    (pkgs.linkFarm "extra-dbus-config" {
      "share/dbus-1/system.d/permit-bluez.conf" = pkgs.writeTextFile {
        name = "permit-bluez.conf";
        text = ''
          <!DOCTYPE busconfig PUBLIC
            "-//freedesktop//DTD D-BUS Bus Configuration 1.0//EN"
            "http://www.freedesktop.org/standards/dbus/1.0/busconfig.dtd">
          <busconfig>
            <policy group="bluetooth">
              <allow send_destination="org.bluez"/>
            </policy>
          </busconfig>
        '';
      };
    })
  ];
}
