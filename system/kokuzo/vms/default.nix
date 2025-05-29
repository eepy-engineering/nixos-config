{
  pkgs,
  microvm,
  ...
}: {
  imports = [
    microvm.nixosModules.host
  ];

  microvm = {
    host.enable = false;

    vms = {
      pia = {
        autostart = false;

        # privateNetwork = false;
        # hostAddress = "192.168.3.1";

        # enableTun = true;
        # bindMounts = {
        #   "/var/opnix-token" = {
        #     hostPath = "/var/opnix-token";
        #     isReadOnly = true;
        #   };
        # };

        specialArgs = {
          isDesktop = false;
        };
        config = _: {
          imports = [
            ./pia.nix
          ];
        };
      };
    };
  };
}
