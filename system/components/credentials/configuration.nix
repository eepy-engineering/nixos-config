{isDesktop, ...}: {
  services.onepassword-secrets = {
    enable = true;
    users = ["rose"];
    tokenFile =
      if isDesktop
      then "/etc/opnix-token"
      else "/var/opnix-token";
    configFile = ./secrets.json;
  };
}
