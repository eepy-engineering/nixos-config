args @ {
  pkgs,
  isDesktop,
  ...
}: {
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  programs._1password-gui.enable = isDesktop;
  programs._1password.enable = true;

  # Rose's user
  home-manager.users.rose = import ./rose/home.nix args;
  users.users.rose = {
    isNormalUser = true;
    description = "Rose Kodsi-Hall";
    extraGroups = ["networkmanager" "wheel"];
    shell = pkgs.nushell;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPORUkOiHY+U4AyZdsF+gRXB/wcKphX1SOgIwwlervZ5"
    ];
  };

  # Aubrey's user :3
  users.users.aubrey = {
    isNormalUser = true;
    description = "Aubrey";
    extraGroups = ["wheel" "plugdev" "wireshark" "libvirtd"];
    shell = pkgs.nushell;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJZn43IczAtHI49eULTaA3GY7Zdoy/gqeEIhev/3ub09"
    ];
  };
  home-manager.users.aubrey = import ./aubrey args;
  programs._1password-gui.polkitPolicyOwners = ["rose" "aubrey"];
}
