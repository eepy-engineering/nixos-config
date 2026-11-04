{ pkgs, ... }: {
  home.packages = [
    pkgs.radicle-node
    pkgs.radicle-desktop
  ];

  services.radicle = {
    node = {
      enable = true;
    };
  };
}
