{
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "smarty4";
  version = "4.5.3";

  src = fetchFromGitHub {
    owner = "smarty-php";
    repo = "smarty";
    rev = "v${finalAttrs.version}";
    hash = "sha256-w0t8oVqmK6Cdpy1OIiRs+1pnFTQQCFJ+gzpMZF5KEaA=";
  };

  installPhase = ''
    mkdir $out
    cp -r libs/* $out
  '';
})
