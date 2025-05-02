{
  pkgs,
  inputs,
  lib,
  config,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  boot.supportedFilesystems = ["zfs"];
  boot.initrd.supportedFilesystems = ["zfs"];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking = {
    hostName = "kokuzo-bosatsu";
    hostId = "8626743f";

    nat = {
      enable = true;
      internalInterfaces = ["ve-+"];
      externalInterface = "eno49";
    };
    interfaces.eno49 = {
      useDHCP = true;
      ipv4.addresses = [
        {
          address = "192.168.2.1";
          prefixLength = 16;
        }
      ];
    };
  };

  services.tailscale = {
    extraUpFlags = ["--advertise-tags=tag:nixos"];
    extraSetFlags = ["--advertise-exit-node"];
    authKeyFile = "/var/lib/opnix/secrets/tailscale.key";
    useRoutingFeatures = "server";
    authKeyParameters.preauthorized = true;
  };
}
