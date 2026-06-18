{ lib, specialArgs, ... }: {
  users.users = {
    walter.enable = false;
    rose.enable = false;
    cysabi.enable = false;
    tetra.extraGroups = [ "wheel" ];
  };
  home-manager.users = lib.mkForce {
    aubrey = ../../user/aubrey;
    # can't deny isDesktop per-user
    # tetra = "${specialArgs.inputs.tetra-config.outPath}/home";
  };
  security.sudo.wheelNeedsPassword = false;
  security.polkit.enable = true;
}
