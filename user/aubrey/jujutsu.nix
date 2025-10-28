{ config, ... }:
{
  programs.jujutsu =
    let
      git = config.programs.git;
      gitCfg = git.extraConfig;
    in
    {
      enable = true;
      settings = {
        user = {
          name = git.userName;
          email = git.userEmail;
        };
        signing = {
          backend = "ssh";
          behavior = "own";
          key = gitCfg.user.signingKey;
          backends.ssh.program = gitCfg."gpg \"ssh\"".program;
        };
      };
    };
}
