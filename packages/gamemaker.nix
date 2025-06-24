{
  gamemakerFlavor ? abort "must provide a flavor",
  gamemakerVersion ? abort "must provide a version",
  gamemakerHash ? abort "must provide a hash",
  lib,
  fetchurl,
  stdenv,
  dpkg,
  autoPatchelfHook,
  nushell,
  zlib,
  libpng,
  libgcc,
  libxml2,
  gettext,
  lttng-ust_2_12,
  bzip2,
  brotli,
  icu,
  buildFHSEnv,
  ...
}:
# todo: fhs env
# need to include a bunch of libraries that can't simply be found with patchelf
stdenv.mkDerivation {
  name = "gamemaker-${lib.toLower gamemakerFlavor}";
  version = gamemakerVersion;

  src = fetchurl {
    url = "https://download.opr.gg/GameMaker-${gamemakerFlavor}-${gamemakerVersion}.deb";
    hash = gamemakerHash;
  };

  buildInputs = [
    stdenv.cc.cc.lib
    zlib
    libpng
    libxml2
    gettext
    lttng-ust_2_12
    bzip2
    brotli.lib
  ];

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
    nushell
  ];

  autoPatchelfIgnoreMissingDeps = true;

  unpackPhase = ''
    dpkg -x $src .
  '';

  patchPhase = ''
    nu -c "open opt/GameMaker-Beta/x86_64/GameMaker.runtimeconfig.json | merge deep {runtimeOptions: {configProperties: {"System.Globalization.Invariant": true}}} | save opt/GameMaker-Beta/x86_64/GameMaker.runtimeconfig.json -f"
    nu -c "open opt/GameMaker-Beta/aarch64/GameMaker.runtimeconfig.json | merge deep {runtimeOptions: {configProperties: {"System.Globalization.Invariant": true}}} | save opt/GameMaker-Beta/aarch64/GameMaker.runtimeconfig.json -f"
  '';

  installPhase = ''
    mkdir -p $out
    cp -r . $out
  '';
}
