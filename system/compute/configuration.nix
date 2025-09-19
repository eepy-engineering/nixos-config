{
  config,
  pkgs,
  ...
}:
{
  # imports = [
  #   ../components/iso.nix
  # ];

  hardware.enableAllFirmware = true;

  boot.initrd.network.enable = true;
  boot.initrd.systemd = {
    enable = true;
    network = {
      enable = true;
      wait-online.extraArgs = [ "--dns" ];
    };
  };

  networking.useDHCP = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  networking.hostName = "compute";

  opnix = {
    secrets = [
      {
        path = "tailscale/authKey";
        reference = "op://Services/a3rsm553bty6eec24l6j6se6re/credential";
      }
    ];
    services = [ "tailscaled-autoconnect.service" ];
  };

  services.tailscale = {
    extraUpFlags = [ "--advertise-tags=tag:nixos" ];
    extraSetFlags = [ "--advertise-exit-node" ];
    useRoutingFeatures = "server";
    authKeyFile = pkgs.asOpnixPath "tailscale/authKey";
    authKeyParameters.preauthorized = true;
  };

  services.getty.autologinUser = "root";
  system.stateVersion = "25.05";
}
