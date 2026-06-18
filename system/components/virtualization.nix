{
  pkgs,
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

    # podman = {
    #   enable = true;
    #   dockerCompat = true;
    # };
    docker.enable = true;
    containers.enable = true;
  };
  boot.enableContainers = true;
}
