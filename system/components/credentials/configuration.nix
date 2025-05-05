{isDesktop, ...}: {
  services.onepassword-secrets = {
    enable = true;
    users = ["rose"];
    tokenFile =
      if isDesktop
      then "/etc/opnix-token"
      else "/var/opnix-token";
    configFile = builtins.toFile "config.json" (builtins.toJSON {
      secrets = [
        {
          path = "samba/credentials";
          reference = "op://Services/Samba Login/formatted";
        }
        {
          path = "tailscale.key";
          reference = "op://Services/Tailscale Auth Key/key";
        }
      ];
    });
  };
}
