{
  pkgs,
  lib,
  isDesktop,
  ...
}:
{
  programs.virt-manager.enable = false;
  virtualisation = {
    spiceUSBRedirection.enable = true;
    libvirtd = {
      enable = false;

      qemu = {
        runAsRoot = true;
        swtpm.enable = true;
        vhostUserPackages = with pkgs; [ virtiofsd ];
      };
    };

    docker = {
      enable = true;
    };
    containers.enable = true;
  };
  boot.enableContainers = true;
}
