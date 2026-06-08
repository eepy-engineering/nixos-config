{
  system.activationScripts = {
    opnix-link = {
      text = ''
        mkdir -p /var
        ln -s /persist/credentials/opnix-token /var/opnix-token
      '';
    };
  };
}
