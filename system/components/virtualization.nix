{
  pkgs,
  isDesktop,
  ...
}:
{
  virtualisation = {
    spiceUSBRedirection.enable = true;
    libvirtd = {
      qemu = {
        runAsRoot = true;
        swtpm.enable = true;
        vhostUserPackages = with pkgs; [ virtiofsd ];
      };
    };
    virtualbox.host = {
      enable = isDesktop;
      addNetworkInterface = true;
    };

    # podman = {
    #   enable = true;
    #   dockerCompat = true;
    # };
    docker.enable = true;
    containers.enable = true;
  };
  boot.enableContainers = true;
}
