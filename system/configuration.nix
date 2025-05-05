{
  config,
  pkgs,
  lib,
  isDesktop,
  ...
}: {
  imports = [
    ./components/credentials/configuration.nix
    ./components/fonts.nix
    ./components/i18n.nix
    ./components/ime.nix
    ./components/nix.nix
    ./components/tank-share.nix
    ./components/ssh/configuration.nix
  ];

  system.stateVersion = "24.11";

  environment.systemPackages = with pkgs; [
    cifs-utils
    opnix
    binutils
    direnv
    openssl
    iperf3
    rsync
    nixos-rebuild
    unzip
    ripgrep
    wget
    git
    direnv
    killall
    neofetch
    nmap
    rclone
    binwalk
    file
    dig
    home-manager.home-manager
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
