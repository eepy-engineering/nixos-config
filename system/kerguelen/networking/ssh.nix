{
  imports = [
    ../../components/ssh
  ];

  services.openssh = {
    settings = {
      UseDns = true;
      PasswordAuthentication = false;
      PermitListen = "any";
      GatewayPorts = "yes";
    };
    hostKeys = [
      {
        bits = 4096;
        path = "/persist/ssh/ssh_host_rsa_key";
        type = "rsa";
      }
      {
        path = "/persist/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }
    ];
  };
}
