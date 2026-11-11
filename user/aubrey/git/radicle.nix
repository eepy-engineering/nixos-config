{ pkgs, ... }: {
  home.packages = [
    # pkgs.radicle-desktop
  ];

  services.radicle.node = {
    package = pkgs.master-pkgs.radicle-node;
    # https://radicle.dev/2026/09/23/disclosure-of-vulnerability-in-network-protocol
    # i'm not bothering until this is fixed
    enable = false;
  };
}
