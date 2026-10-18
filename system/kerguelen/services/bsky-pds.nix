{
  services.bluesky-pds = {
    enable = true;
    pdsadmin.enable = true;
    environmentFiles = [ "/persist/pds/env" ];
    settings = {
      PDS_PORT = 3001;
      PDS_HOSTNAME = "sanae6.ca";
      PDS_INVITE_REQUIRED = "true";
      PDS_DATA_DIRECTORY = "/persist/pds";
      PDS_BLOBSTORE_DISK_LOCATION = "/persist/pds/blocks";
    };
  };

  systemd.services.bluesky-pds = {
    serviceConfig = {
      BindPaths = "/persist/pds";
    };
  };

  users = {
    users.pds.uid = 503;
    groups.pds.gid = 503;
  };
}
