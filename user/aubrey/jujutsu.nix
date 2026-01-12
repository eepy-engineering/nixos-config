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
        ui = {
          default-command = "log";
        };
        git = {
          sign-on-push = true;
        };
      };
    };

  programs.nushell = {
    extraConfig = ''
      alias jjgf = jj git fetch
      alias jjgp = jj git push
    '';
  };
}
