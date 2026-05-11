{
  imports = [ ../containers/smo-wiki ];

  fileSystems."/persist/smo-wiki-mysql" = {
    device = "apps/smo-wiki-mysql";
    fsType = "zfs";
    depends = [ "/" ];
  };

  smo-wiki = {
    enable = true;
    site = "smo.wiki";
    mysqlDataDir = "/persist/smo-wiki-mysql";
    mysqlBackupDir = "/mnt/tank/smo-wiki-backups";
  };
}
