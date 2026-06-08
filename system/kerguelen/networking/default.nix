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
    # nftables.enable = true;
    nat = {
      enable = true;
      internalInterfaces = [ "ve-+" ];
      externalInterface = "enp0s25";
      enableIPv6 = true;
    };
  };
  systemd.network = {
    enable = true;
    networks = {
      "10-lan" = {
        matchConfig.Name = "enp0s25";
        DHCP = "yes";
        linkConfig.RequiredForOnline = "routable";
      };
    };
  };
  services.resolved = {
    enable = true;
    settings = {
      Resolve = {
        DNSSEC = "true";
        Domains = [ "~." ];
        FallbackDNS = [
          "1.1.1.1#one.one.one.one"
          "1.0.0.1#one.one.one.one"
          "2606:4700:4700::1111"
          "2606:4700:4700::1001"
        ];
        DNSOverTLS = "true";
      };
    };
  };
}
