{...}: {
  services.onepassword-secrets = {
    enable = true;
    users = ["rose"];
    configFile = ./secrets.json;
  };
}
