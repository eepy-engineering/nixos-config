{
  imports = [
    ../../containers/smo-wiki
  ];

  fileSystems = {
    "/persist/smo-wiki" = {
      device = "/dev/disk/by-uuid/15ea7064-494a-4d56-b4f8-6897054f7fa3";
      fsType = "btrfs";
      options = [
        "compress=zstd"
        "subvol=persist/smo-wiki"
      ];
      depends = [ "/persist" ];
    };
  };

  smo-wiki = {
    enable = true;
    site = "test.smo.wiki";
    mysqlDataDir = "/persist/smo-wiki/mysql-data";
    mysqlBackupDir = "/persist/smo-wiki/mysql-backup";
    mediawikiDir = "/persist/smo-wiki/mediawiki-storage";
    cloudflaredPem = "gmvjrreos46vx526brke3s7wnu";
    cloudflaredTunnel = "ponvw3bhpeftm3wgsr2vxd2siq";
    cloudflaredTunnelId = "c608eb58-446a-48e0-bc5f-506c7045d1cb";
  };
}
