{ config, ... }: {
  services.forgejo = {
    enable = true;
    stateDir = "/mnt/forgejo";
    settings = {
      server = {
        DOMAIN = "git.sanae6.ca";
        ROOT_URL = "https://git.sanae6.ca/";
        SSH_DOMAIN = "kerguelen";
        START_SSH_SERVER = true;
        SSH_PORT = 2222;
        LANDING_PAGE = "explore";
      };
      service = {
        DISABLE_REGISTRATION = true;
      };
    };
  };

  users = {
    users.${config.services.forgejo.user}.uid = 502;
    groups.${config.services.forgejo.group}.gid = 502;
  };

  system.stateVersion = "26.11";
}
