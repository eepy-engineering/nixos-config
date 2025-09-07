{...}: {
  services.samba = {
    enable = true;
    settings = {
      global = {
        "server max protocol" = "SMB3_11";
        "smb3 unix extensions" = "yes";
      };
      tank = {
        "path" = "/mnt/tank";
        # "browseable" = "yes";
        "read only" = "no";
        "guest ok" = "no";
        # "create mask" = "0644";
        # "directory mask" = "0755";
        # "map acl inherit" = "yes";
        # "inherit acls" = "yes";
      };
    };
    openFirewall = true;
  };
}
