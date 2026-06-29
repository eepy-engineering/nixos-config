{
  specialArgs,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ../../user/configuration.nix
  ];

  users = {
    mutableUsers = false;
    users = {
      walter.enable = false;
      rose.enable = false;
      cysabi.enable = false;
      tetra = {
        enable = lib.mkForce false;
        uid = 1001;
      };
      tetra.extraGroups = [ "wheel" ];
      aubrey = {
        uid = 1000;
      };
      red = {
        uid = 1002;
        isNormalUser = true;
        description = "red";
        shell = "${pkgs.shadow}/bin/nologin";
        openssh.authorizedKeys.keys = [
          (builtins.readFile ./red.pub)
        ];
      };
    };
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
