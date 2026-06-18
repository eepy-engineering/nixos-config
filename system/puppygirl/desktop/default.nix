{
  imports = [
    ./1password.nix
    ./fonts.nix
    ./greeter.nix
    ./layouts
    ./login.nix
    ./wm.nix
    ./xdg.nix
  ];

  services.logind.settings.Login.HandlePowerKey = "suspend";
  services.printing.enable = true;

  environment.sessionVariables = {
    "NIXOS_OZONE_WL" = "1";
  };
}
