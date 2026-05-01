{ stdenv, fetchFromGitHub }:
stdenv.mkDerivation {
  name = "ilo-sitelen";

  src = fetchFromGitHub {
    owner = "balt-dev";
    repo = "ilo-sitelen";
    rev = "3c6e0010ef51f740737f8ae1ee43402e9de5cd51";
    sha256 = "sha256-Mx/u63ZE8uMrdAG/4MsOtQr0Mm5V3Yp9AH0n6y1jBew=";
  };

  buildPhase = ''
    mkdir -p $out/share/fcitx5
    cp -r $src/table $src/inputmethod $out/share/fcitx5
  '';
}
