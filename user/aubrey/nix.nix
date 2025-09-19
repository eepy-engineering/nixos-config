{
  pkgs,
  lib,
  ...
}:
{
  nix = {
    package = lib.mkDefault pkgs.nix;
    settings = {
      experimental-features = "nix-command flakes local-overlay-store";
      accept-flake-config = true;
      warn-dirty = false;
    };
  };
}
