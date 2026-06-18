{
  imports = [
    ./ny-vpn.nix
    ./pia-vpn.nix
    ./resolved.nix
    ./tailscale.nix
  ];

  networking = {
    hostName = "puppygirl";
    nameservers = [
      "1.1.1.1"
      "1.0.0.1"
      "2606:4700:4700::1111"
      "2606:4700:4700::1001"
    ];
    hosts = {
      "100.70.181.9" = [ "kokuzo" ];
    };
    useNetworkd = true;
    networkmanager.wifi.powersave = false;

    firewall.enable = false;
  };

  systemd.network.wait-online.enable = false;
}
