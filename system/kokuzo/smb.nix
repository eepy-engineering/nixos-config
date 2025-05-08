{...}: {
  services.samba = {
    enable = true;
    settings = {
      tank = {
        "path" = "/mnt/tank";
        "browseable" = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "create mask" = "0644";
        "directory mask" = "0755";
        "smb3 unix extensions" = "yes";
      };
    };
    openFirewall = true;
  };
}
