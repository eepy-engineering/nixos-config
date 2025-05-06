{
  config,
  pkgs,
  ...
}: {
  services.k3s = {
    enable = true;
    role = "server";
    token = "todo get a real key dumbass";
    clusterInit = true;
    extraFlags = [
      "--tls-san=100.70.181.9"
      "--tls-san=kokuzo.tailc38f.ts.net"
    ];
  };

  services.dockerRegistry = {
    enable = true;
  };
}
