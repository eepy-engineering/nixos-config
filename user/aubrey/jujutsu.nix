{
  config,
  lib,
  isDesktop,
  ...
}:
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
          backends.ssh.program = lib.mkIf isDesktop gitCfg."gpg \"ssh\"".program;
        };
        ui = {
          default-command = "log";
          movement.edit = true;
        };
        aliases = {
          a = [ "abandon" ];
          n = [ "next" ];
          p = [ "prev" ];
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
      def --wrapped jjbm [...args] {
        jj b m -t 'heads(::@ ~ empty())' ...$args
      }
    '';
  };
}
