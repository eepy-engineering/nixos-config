args @ {pkgs, ...}: {
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  programs._1password-gui.enable = true;
  programs._1password.enable = true;

  # Rose's user
  home-manager.users.rose = import ./rose/home.nix args;
  users.users.rose = {
    isNormalUser = true;
    description = "Rose Kodsi-Hall";
    extraGroups = ["networkmanager" "wheel"];
    shell = pkgs.nushell;
  };
  programs._1password-gui.polkitPolicyOwners = ["rose"];
}
