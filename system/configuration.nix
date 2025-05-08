{
  config,
  pkgs,
  lib,
  isDesktop,
  ...
}: {
  imports = [
    ./components/credentials.nix
    ./components/fonts.nix
    ./components/i18n.nix
    ./components/ime.nix
    ./components/nix.nix
    ./components/ssh
  ];

  system.stateVersion = "24.11";

  environment.systemPackages = with pkgs; [
    # nix
    opnix
    direnv
    nixos-rebuild
    home-manager.home-manager
    nix-search

    # cli tools
    cifs-utils
    binutils
    openssl
    iperf3
    rsync
    unzip
    ripgrep
    wget
    git
    killall
    neofetch
    nmap
    rclone
    binwalk
    file
    dig
    bottom
    htop

    (writeNushellScriptBin "reboot-kexec" ''
      let cmdline = $"init=(readlink -f /nix/var/nix/profiles/system/init) $(open /nix/var/nix/profiles/system/kernel-params)";
      sudo kexec -l /nix/var/nix/profiles/system/kernel --initrd=/nix/var/nix/profiles/system/initrd $"--command-line=($cmdline)"
      systemctl kexec
    '')
  ];

  services = {
    libinput.enable = true;

    pipewire = {
      enable = isDesktop;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };

    tailscale.enable = true;
  };

  hardware = {
    graphics.enable = isDesktop;
  };

  programs.dconf.enable = true;

  security.rtkit.enable = isDesktop;
}
