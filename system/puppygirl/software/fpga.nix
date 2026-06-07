{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    openfpgaloader
  ];
  
  services.udev = {
    packages = [
      (pkgs.stdenv.mkDerivation {
        name = "openfpgaloader-udev";
        src = pkgs.openfpgaloader.src;

        buildPhase = ''
          mkdir -p $out/etc/udev/rules.d
          ln -s $src/99-openfpgaloader.rules $out/etc/udev/rules.d
        '';
      })
    ];
  };
}