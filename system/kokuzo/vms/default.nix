{
  pkgs,
  microvm,
  inputs,
  ...
}: {
  imports = [
    microvm.nixosModules.host
  ];

  # systemd.network.netdevs."br0" = {
  #   netdevConfig = {
  #     Name = "br0";
  #     Kind = "bridge";
  #   };
  # };

  # systemd.network.networks."10-lan-bridge" = {
  #   matchConfig.Name = "br0";
  #   networkConfig = {
  #     Address = ["192.168.2.1/24" "2001:db8::a/64"];
  #     Gateway = "192.168.1.1";
  #     DNS = ["192.168.1.1"];
  #     IPv6AcceptRA = true;
  #   };
  #   linkConfig.RequiredForOnline = "routable";
  # };

  # networking = {
  #   bridges.br0.interfaces = ["eno49" "vm-pia"];
  #   interfaces.br0.ipv4.addresses = [
  #     {
  #       address = "192.168.2.1";
  #       prefixLength = 24;
  #     }
  #   ];
  # };

  microvm = {
    host.enable = true;

    vms = {
      pia = {
        autostart = false;

        specialArgs = {
          isDesktop = false;
          inherit inputs;
        };
        config = _: {
          imports = [
            ./pia.nix
          ];
        };
      };
    };
  };
}
