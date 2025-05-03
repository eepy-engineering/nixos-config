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

  boot.loader = {
    grub = {
      enable = true;
      zfsSupport = true;
      efiSupport = true;
      efiInstallAsRemovable = true;
      mirroredBoots = [
        {
          devices = ["nodev"];
          path = "/boot";
        }
      ];
    };
    efi.canTouchEfiVariables = true;
  };

  boot.supportedFilesystems = ["zfs"];
  boot.initrd.supportedFilesystems = ["zfs"];

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
