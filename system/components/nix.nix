{
  pkgs,
  inputs,
  ...
}: {
  nix.package = pkgs.lix;
  nix.settings.experimental-features = ["nix-command" "flakes"];
  nixpkgs = {
    config = {
      allowUnfree = true;
      allowInsecurePredicate = pkg: true;
    };

    overlays = [
      # Opnix overlay for ease of addition
      (final: prev: {
        opnix = inputs.opnix.packages.${pkgs.system}.default {pkgs = final;};
      })
    ];
  };
}
