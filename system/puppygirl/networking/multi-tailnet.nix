{
  # just incomplete

  imports = [
    ./multi-tailnet-module.nix
  ];

  services.multi-tailnet = {
    enable = false;
    tailnets = {
      roob = {
        authKeyFile = "/etc/roob.tskey";
        ipv4Address = "192.168.101.1";
        ipv4AddressSub = "192.168.101.2";
        ipv4AddressDns = "192.168.101.53";
      };
    };
  };
}
