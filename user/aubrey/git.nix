{
  pkgs,
  lib,
  ...
}:
{
  programs.git = {
    enable = true;
    package = pkgs.stable-pkgs.git;

    lfs.enable = true;

    settings = {
      user = {
        name = "Aubrey Taylor";
        email = "aubrey@hall.ly";
        signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJZn43IczAtHI49eULTaA3GY7Zdoy/gqeEIhev/3ub09";
      };
      gpg.format = "ssh";
      "gpg \"ssh\"".program = "${lib.getExe' pkgs._1password-gui "op-ssh-sign"}";
      commit.gpgsign = true;
      init.defaultBranch = "main";
      pull.rebase = true;
    };
  };
}
