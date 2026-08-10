{ pkgs, config, ... }: {
  users = {
    users.teamspeak = {
      isSystemUser = true;
      uid = config.ids.uids.teamspeak;
      name = "Teamspeak";
      group = "teamspeak";
    };
    groups.teamspeak = {
      name = "teamspeak";
      gid = config.ids.gids.teamspeak;
    };
  };
  # ids = {
  #   uids.teamspeak = 502;
  #   gids.teamspeak = 502;
  # };

  containers = {
    teamspeak = {
      autoStart = false;

      config = {
        imports = [ ./configuration.nix ];
        nixpkgs.pkgs = pkgs;
      };

      bindMounts = {
        "/mnt/teamspeak" = {
          hostPath = "/persist/teamspeak";
          isReadOnly = false;
        };
      };
    };
  };

}
