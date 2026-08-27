{ pkgs, ... }: {
  imports = [
    ../../components/pia
  ];

  services.pia-vpn = {
    # region = "ca_toronto";
  };

  opnix = {
    secrets = [
      {
        path = "pia/userpass";
        reference = "op://Services/Private Internet Access/userpass";
      }

    ];
  };
  services.pia = {
    enable = true;
    authUserPassFile = pkgs.asOpnixPath "pia/userpass";
  };
}
