_: {
  programs.ssh = {
    enable = true;
    forwardAgent = true;
    extraConfig = ''
      Host *
        IdentityAgent ~/.1password/agent.sock
      Host sanae6.ca
        User sanae
      Host vm-eepy
        User eepy
      Host vm-pia
        User eepy
    '';
  };
}
