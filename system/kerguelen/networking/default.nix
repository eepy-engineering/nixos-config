{
  imports = [
    ./tailscale.nix
    ../../components/ssh
  ];

  networking = {
    useNetworkd = true;
    nameservers = [
      "1.1.1.1#one.one.one.one"
      "1.0.0.1#one.one.one.one"
    ];
    firewall.enable = false;
  };
  systemd.network = {
    enable = true;
    networks = {
      "10-lan" = {
        matchConfig.Name = "enp0s25";
        address = [
          # configure addresses including subnet mask
          "192.168.2.1/16"
        ];
        DHCP = "yes";
        networkConfig.DefaultRouteOnDevice = true;
        linkConfig.RequiredForOnline = "routable";
      };
    };
  };

  services.resolved = {
    enable = true;
    dnssec = "true";
    domains = [ "~." ];
    fallbackDns = [
      "1.1.1.1#one.one.one.one"
      "1.0.0.1#one.one.one.one"
    ];
    dnsovertls = "true";
  };
}
