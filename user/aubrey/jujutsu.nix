{ config, ... }:
{
  programs.jujutsu =
    let
      git = config.programs.git;
    in
    {
      enable = true;
      settings = {
        user = {
          name = git.userName;
          email = git.userEmail;
        };
      };
    };
}
