{
  config,
  pkgs,
  lib,
  ...
}: {
  system.stateVersion = "24.11";

  nix.settings.experimental-features = ["nix-command" "flakes"];
  nixpkgs.config.allowUnfree = true;

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };
  };

  environment.systemPackages = [
    pkgs.tailscale
    pkgs.cifs-utils
  ];

  services = {
    xserver = {
      enable = true;
      videoDrivers = ["nvidia"];
      xkb = {
        layout = "us";
        variant = "";
      };
    };

    desktopManager.plasma6.enable = true;

    libinput.enable = true;

    pulseaudio.enable = false;

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
  };

  services.tailscale.enable = true;

  hardware = {
    nvidia = {
      modesetting.enable = true;
      open = true;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };

    bluetooth.enable = true;
    bluetooth.powerOnBoot = true;

    graphics.enable = true;
  };

  security.rtkit.enable = true;

  fonts = {
    fontconfig.useEmbeddedBitmaps = true;
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

  i18n.inputMethod = {
    type = "fcitx5";
    enable = true;
    fcitx5.addons = with pkgs; [
      fcitx5-mozc
      fcitx5-gtk
    ];
  };

  # fileSystems."/mnt/tank" = {
  #   device = "//shared-server-store/tank";
  #   fsType = "cifs";
  #   options = [import ../util/cifs-options.nix lib {
  #     x-systemd = {
  #       automount = true;
  #       idle-timeout = 60;
  #       device-timeout = "5s";
  #       mount-timeout = "5s";
  #     };

  #     noauto = true;

  #     credentials = ./samba-credentials
  #   }];
  # };
}
