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
  ];

  system.stateVersion = "24.11";

  environment.systemPackages = [
    pkgs.cifs-utils
  ];

  services = {
    desktopManager.plasma6.enable = isDesktop;

    libinput.enable = true;

    pipewire = {
      enable = isDesktop;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };

    openssh = {
      enable = true;
      settings = {
        X11Forwarding = isDesktop;
        PermitRootLogin = "no";
      };
    };
    tailscale.enable = true;
  };

  hardware = {
    # TODO: Not working :(
    bluetooth.enable = isDesktop;
    bluetooth.powerOnBoot = true;

    graphics.enable = isDesktop;
  };

  security.rtkit.enable = isDesktop;
}
