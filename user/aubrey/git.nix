{
  pkgs,
  lib,
  ...
}:
{
  programs.git = {
    enable = true;

    lfs.enable = true;

    settings = {
      user = {
        name = "Aubrey Taylor";
        email = "aubrey@hall.ly";
      };
      gpg.format = "ssh";
      "gpg \"ssh\"".program = "${lib.getExe' pkgs._1password-gui "op-ssh-sign"}";
      commit.gpgsign = true;
      user.signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJZn43IczAtHI49eULTaA3GY7Zdoy/gqeEIhev/3ub09";
      init.defaultBranch = "main";
      pull.rebase = true;
    };
  };
}
