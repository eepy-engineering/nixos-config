{
  services.syncthing = {
    enable = true;
    user = "aubrey";
    group = "users";
    dataDir = "/home/aubrey/Sync";
    configDir = "/home/aubrey/.config/syncthing";
  };
}
