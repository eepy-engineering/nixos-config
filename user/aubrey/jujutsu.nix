{ config, ... }:
{
  programs.jujutsu =
    let
      git = config.programs.git;
      gitCfg = git.settings;
    in
    {
      enable = true;
      settings = {
        user = {
          name = gitCfg.user.name;
          email = gitCfg.user.email;
        };
        signing = {
          backend = "ssh";
          behavior = "own";
          key = gitCfg.user.signingKey;
          backends.ssh.program = gitCfg."gpg \"ssh\"".program;
        };
        git = {
          sign-on-push = true;
        };
      };
    };
}
