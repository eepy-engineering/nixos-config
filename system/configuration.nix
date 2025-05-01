{
  config,
  pkgs,
  lib,
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
    desktopManager.plasma6.enable = true;

    libinput.enable = true;

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
  };

  services.tailscale = {
    enable = true;
  };

  hardware = {
    # TODO: Not working :(
    bluetooth.enable = true;
    bluetooth.powerOnBoot = true;

    graphics.enable = true;
  };

  security.rtkit.enable = true;

  fonts = {
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      liberation_ttf
      fira-code
      fira-code-symbols
      mplus-outline-fonts.githubRelease
      dina-font
      proggyfonts
    ];
  };
}
