{ pkgs, lib, ... }: {
  nix = {
    package = lib.mkForce pkgs.nix;
    settings = {
      experimental-features = lib.mkForce [
        "nix-command"
        "flakes"
      ];
    };
  };
}
