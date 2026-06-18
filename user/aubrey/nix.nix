{
  pkgs,
  lib,
  ...
}:
{
  nix = {
    package = lib.mkDefault pkgs.nix;
    settings = {
      experimental-features = "nix-command flakes";
      accept-flake-config = true;
      warn-dirty = false;
    };
  };
}
