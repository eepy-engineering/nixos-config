{
  imports = [
    ./audio.nix
    ./backups.nix
    ./bluetooth.nix
    ./boot.nix
    ./desktop
    ./filesystems.nix
    ./hardware.nix
    ./input.nix
    ./locale.nix
    ./networking
    ./software
    ./users.nix
    ./wireless.nix

    ../configuration.nix
    ../../user/configuration.nix
  ];
}
