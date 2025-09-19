{
  pkgs,
  inputs,
  lib,
}:
(pkgs.surfer.overrideAttrs (old: {
  version = "0.4.0-dev";
  src = inputs.surfer;

  cargoDeps = old.cargoDeps.overrideAttrs (older: {
    version = "0.4.0-dev";
    vendorStaging = older.vendorStaging.overrideAttrs (
      lib.const {
        version = "0.4.0-dev";
        src = inputs.surfer;
        outputHash = "sha256";
      }
    );
  });
}))
