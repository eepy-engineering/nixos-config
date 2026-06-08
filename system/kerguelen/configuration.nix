{
  imports = [
    ./boot.nix
    ./credentials.nix
    ./filesystem.nix
    ./hardware.nix
    ./networking
    ../components/nix.nix
    ./services
    ./users.nix
    ./virtualisation.nix
  ];

  networking.hostName = "kerguelen";

  system.stateVersion = "26.05"; # do Not change this
}
