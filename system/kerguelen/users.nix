{ specialArgs, lib, ... }:
{
  imports = [
    ../../user/configuration.nix
  ];
  users.users = {
    walter.enable = false;
    rose.enable = false;
    cysabi.enable = false;
    tetra.enable = lib.mkForce false;
    tetra.extraGroups = [ "wheel" ];
  };
  security.sudo.wheelNeedsPassword = false;
  home-manager = {
    extraSpecialArgs = specialArgs;
    users = lib.mkForce {
      aubrey = ../../user/aubrey;
      # tetra = "${specialArgs.inputs.tetra-config.outPath}/home";
    };
  };
}
