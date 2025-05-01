{config}: {
  services = {
    xserver = {
      enable = true;
      videoDrivers = ["nvidia"];
      xkb = {
        layout = "us";
        variant = "";
      };
    };

    nvidia = {
      modesetting.enable = true;
      open = true;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };
  };
}
