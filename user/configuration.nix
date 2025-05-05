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
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKpmuAVPQUMOZhy+a/54Rh/vwbhx9j5HU2rnhyExw01r"
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

  # Walter's user
  users.users.walter = {
    isNormalUser = true;
    description = "Walter Min";
    extraGroups = ["wheel"];
    shell = pkgs.bash;
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCOJGRyAn1LVGP17eKMCHV0CDf+1Iyyltd2q1xSa1hS4AoIxdu07mHLFpnSmp/T9t4JMnWhp3eIIlFtolx4oMAXewH/JWL0H6i6CGhe91zhiwGEaxDmB0tZhCORrc8ApJQSHaHgwvziOjwQrtLYLIP4Tp8nojIlT/Rv5T+UAEAlnCV7hFxdbPf5x4s8CKOAj70H0wHlbn6BDuRjnld8dFqkmb4oNyIfxCyDvxw6ZKTTIz6l8EaBeyiIjl7FB4uyfaTPevhT82V8MEAtvs3UNvKSeXUuc1KZxTMKuys6L/qlEezp8uYMs3gHrTHkCJmqYAzMjVk2JFRCoaRKWCgI4hpJ"
    ];
  };
}
