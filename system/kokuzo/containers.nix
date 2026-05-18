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

  virtualisation = {
    oci-containers.containers = {
      # https://github.com/blacktop/docker-ghidra
      ghidra = {
        image = "blacktop/ghidra";
        autoStart = true;
        cmd = [ "server" ];
        ports = [
          "13100:13100"
          "13101:13101"
          "13102:13102"
        ];
        environment = {
          MAXMEM = "500M";
          GHIDRA_USERS = "aubrey tetra miley jenn amy";
          GHIDRA_IP = "hall.ly";
        };
        volumes = [ "/mnt/tank/ghidra-repositories:/repos" ];
      };
    };
  };
}
