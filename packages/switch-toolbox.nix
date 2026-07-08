{
  stdenv,
  fetchzip,
  fetchurl,
  makeDesktopItem,
  wineWow64Packages,
  writeShellScriptBin,
  unzip,
  ...
}:
stdenv.mkDerivation rec {
  name = "switch-toolbox-package";
  version = "1.0";

  src = stdenv.mkDerivation {
    name = "toolbox-zip";
    unpackPhase = ''
      ${unzip}/bin/unzip -d $out ${./Toolbox-Latest.zip}
    '';
  };
  logo = fetchurl {
    url = "https://raw.githubusercontent.com/KillzXGaming/Switch-Toolbox/refs/heads/master/Toolbox/Resources/Logo.png";
    sha256 = "sha256-B3cpz0yXSrRid8a7/L+93ZLXNawGg7XadH6jrYoCqxs=";
  };

  wine-overlay = "\\$HOME/.local/share/switch-toolbox/wine";
  program-overlay = "\\$HOME/.local/share/switch-toolbox/data";
  program-workdir = "\\$HOME/.local/share/switch-toolbox/workdir";

  shellscript = writeShellScriptBin "switch-toolbox" (
    "unshare -rm sh -c \""
    + "export MYTMPDIR=\\$(mktemp -d) && "
    + "cd \\$MYTMPDIR && "
    + "mkdir program-overlay && "
    + "mkdir -p ${program-overlay} ${program-workdir} && "
    + "mkdir -p ${program-overlay}/Lib/Plugins && "
    + "mount -t overlay -o lowerdir=${src},upperdir=${program-overlay},workdir=${program-workdir} none program-overlay && "
    + "WINEPREFIX=${wine-overlay} ${wineWow64Packages.staging}/bin/wine program-overlay/Toolbox.exe"
    + "\""
  );

  desktopItem = makeDesktopItem {
    desktopName = "Switch-Toolbox";
    name = "toolbox-desktop10";
    exec = "switch-toolbox";
    categories = [
      "GNOME"
      "GTK"
      "Development"
    ];
    icon = "switch-toolbox";
    startupWMClass = "toolbox.exe";
  };

  installPhase = ''
    mkdir -p $out/share $out/share/icons $out/share/applications $out/bin
    cp -r ${desktopItem}/share/applications/* $out/share/applications
    cp ${logo} $out/share/icons/switch-toolbox.png
    cp ${shellscript}/bin/switch-toolbox $out/bin/switch-toolbox
  '';

}
