{
  imports = [
    ./tailscale.nix
    ../../components/ssh
  ];

  networking = {
    useNetworkd = true;
    
    firewall.enable = false;
  };
  systemd.network = {
    enable = true;
    networks = {
      "10-lan" = {
        matchConfig.Name = "enp0s25";
        address = [
          # configure addresses including subnet mask
          "192.168.2.1/24"
        ];
        routes = [
          { Gateway = "192.168.1.1"; }
        ];
        linkConfig.RequiredForOnline = "routable";
      };
    };
  };
  
}
