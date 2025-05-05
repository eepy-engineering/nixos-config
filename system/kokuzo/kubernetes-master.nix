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
  };
}
