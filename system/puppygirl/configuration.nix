{
  imports = [
    ./backups.nix
    ./bluetooth.nix
    ./boot.nix
    ./desktop
    ./filesystems.nix
    ./locale.nix
    ./networking
    ./software
    ./users.nix
    ./wireless.nix

    ../configuration.nix
    ../../user/configuration.nix
  ];
}
