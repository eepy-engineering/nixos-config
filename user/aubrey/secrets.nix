{ isDesktop, ... }:
{
  programs = {
    onepassword-secrets = {
      # nothing to hide :3 (kept in case i need secrets for something)
      enable = false;
      tokenFile = if isDesktop then "/etc/opnix-token" else "/var/opnix-token";
      secrets = [ ];
    };
  };
}
