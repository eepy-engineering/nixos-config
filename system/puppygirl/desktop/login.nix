{
  services.logind = {
    enable = true;
    settings.Login.HandlePowerKey = "suspend";
  };
}
