{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  # Rose's user
  home-manager.users.rose = import ./rose/home.nix;
  users.users.rose = {
    isNormalUser = true;
    description = "Rose Kodsi-Hall";
    extraGroups = ["networkmanager" "wheel"];
  };

  # Optionally, use home-manager.extraSpecialArgs to pass
  # arguments to home.nix
}
