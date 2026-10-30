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

    # The static address only. With DHCP on as well, dhcpcd adopted
    # 192.168.2.1 as a lease at boot, couldn't renew it with the router and
    # deleted it, and k3s's etcd (registered at 192.168.2.1) won't start
    # without it: the 2026-10-05 reboot left k3s down for ~35h.
    useDHCP = false;
    defaultGateway = "192.168.1.1";
    nameservers = [ "192.168.1.1" ];
    interfaces.eno49 = {
      useDHCP = false;
      ipv4.addresses = [
        {
          address = "192.168.2.1";
          prefixLength = 16;
        }
      ];
    };
  };
}
