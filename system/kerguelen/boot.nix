{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
    useXkbConfig = true;
  };
  
  services.xserver.xkb.layout = "us";
  services.xserver.xkb.options = "caps:escape";
}
