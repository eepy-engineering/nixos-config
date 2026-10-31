{
  imports = [
    ../components/credentials.nix
  ];

  opnix.outputDir = "/persist/credentials/directory";

  system.activationScripts = {
    opnix-link = {
      text = ''
        mkdir -p /var
        rm /var/opnix-token
        ln -s /persist/credentials/opnix-token /var/opnix-token
      '';
    };
  };
}
