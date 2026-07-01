{
  imports = [ ../containers/smo-wiki ];

  fileSystems = {
    "/persist/smo-wiki-mysql" = {
      device = "apps/smo-wiki-mysql";
      fsType = "zfs";
      depends = [ "/" ];
    };
    "/persist/smo-wiki-mediawiki-storage" = {
      device = "apps/smo-wiki";
      fsType = "zfs";
      depends = [ "/" ];
    };
  };

  smo-wiki = {
    enable = true;
    site = "smo.wiki";
    mysqlDataDir = "/persist/smo-wiki-mysql";
    mysqlBackupDir = "/mnt/tank/smo-wiki-backups";
    mediawikiDir = "/persist/smo-wiki-mediawiki-storage";
    cloudflaredPem = "h3ewjwxbus3gops6qi4naiwpn4";
    cloudflaredTunnel = "ty24aofrqct3solie6v2iv7fke";
    cloudflaredTunnelId = "9594cc82-a65e-427b-bc88-35c3985402b6";
    tailscaleHostName = "kokuzo.tailc38f.ts.net";
    syncthing = "iwijwbx46bjzbewhly5wik3bba";
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
