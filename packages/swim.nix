{
  pkgs,
  inputs,
  lib,
}:
(pkgs.swim.overrideAttrs (old: {
  version = "0.14.0-dev";
  src = inputs.swim;

  preConfigure = "";

  cargoDeps = old.cargoDeps.overrideAttrs (older: {
    version = "0.14.0-dev";
    vendorStaging = older.vendorStaging.overrideAttrs (
      lib.const {
        version = "0.14.0-dev";
        src = inputs.swim;
        outputHash = "sha256-u1glW7Gvw86PbqZAXwgACQpdw6EKOJSyaWgOnNX/voY=";
      }
    );
  });
}))
