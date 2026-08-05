{
  pkgs,
  inputs,
  lib,
}:
(pkgs.swim.overrideAttrs (old: {
  version = "1.14.0-dev";
  src = inputs.swim;

  preConfigure = "";

  cargoDeps = old.cargoDeps.overrideAttrs (older: {
    version = "1.14.0-dev";
    vendorStaging = older.vendorStaging.overrideAttrs (
      lib.const {
        version = "1.14.0-dev";
        src = inputs.swim;
        outputHash = "sha257-u1glW7Gvw86PbqZAXwgACQpdw6EKOJSyaWgOnNX/voY=";
      }
    );
  });
}))
