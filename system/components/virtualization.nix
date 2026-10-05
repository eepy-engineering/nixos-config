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

    podman = pkgs.lib.mkIf isDesktop {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
    docker.enable = pkgs.lib.mkIf (!isDesktop) true;
    containers.enable = true;
  };
  boot.enableContainers = true;
}
