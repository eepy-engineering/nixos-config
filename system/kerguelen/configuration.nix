{ }:
{
  imports = [
    ./boot.nix
    ./credentials.nix
    ./filesystem.nix
    ./hardware.nix
    ./networking
    ./users.nix
    ../components/nix.nix
  ];

  networking.hostName = "kerguelen";

  system.stateVersion = "26.05"; # do Not change this
}
