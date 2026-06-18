{ config, pkgs, ... }: {
  imports = [
    ../../components/virtualization.nix
  ];

  programs.virt-manager.enable = true;

  virtualisation.libvirtd = {
    enable = true;

    qemu = {
      runAsRoot = true;
      swtpm.enable = true;
      vhostUserPackages = with pkgs; [ virtiofsd ];
    };
  };

  environment.etc = {
    qemu = {
      target = "qemu/package";
      source = config.virtualisation.libvirtd.qemu.package;
    };
    virtiofsd = {
      target = "qemu/virtiofsd-package";
      source = pkgs.virtiofsd;
    };
  };
}
