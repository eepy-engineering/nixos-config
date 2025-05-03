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
      efiInstallAsRemovable = false;
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
    extraSetFlags = ["--advertise-exit-node"];
    useRoutingFeatures = "server";
  };

  services.samba = {
    enable = true;
    securityType = "user";
    openFirewall = true;
    settings = {
      "tank" = {
        "path" = "/mnt/tank";
        "browseable" = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "create mask" = "0644";
        "directory mask" = "0755";
        "force user" = "";
        "force group" = "users";
      };
    };
  };

  services.getty.autologinUser = "root";
}
