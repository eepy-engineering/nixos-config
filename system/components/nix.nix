{
  pkgs,
  inputs,
  ...
}:
{
  nix = {
    package = pkgs.nix;
    settings = {
      trusted-users = [ "@wheel" ];
      experimental-features = [
        "nix-command"
        "flakes"
        "local-overlay-store"
      ];
    };
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowInsecurePredicate = pkg: true;
    };

    overlays = [
      # Opnix overlay for ease of addition
      (final: prev: {
        opnix = inputs.opnix.packages.${pkgs.stdenv.hostPlatform.system}.default { pkgs = final; };
      })
    ];
  };
}
