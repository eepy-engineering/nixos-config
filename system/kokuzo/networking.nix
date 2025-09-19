{ ... }:
{
  networking = {
    hostName = "kokuzo";
    hostId = "8626743f";

    firewall.enable = false;

    nat = {
      enable = true;
      internalInterfaces = [ "ve-+" ];
      externalInterface = "eno49";
    };

    useDHCP = true;
    defaultGateway = "192.168.1.1";
    nameservers = [ "192.168.1.1" ];
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

  systemd.network = {
    enable = false;

    networks."10-lan" = {
      matchConfig.Name = [
        "eno49"
        "vm-*"
      ];
      networkConfig = {
        Bridge = "br0";
      };
    };

    netdevs."br0" = {
      netdevConfig = {
        Name = "br0";
        Kind = "bridge";
      };
    };
  };
}
