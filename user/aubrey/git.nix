{
  pkgs,
  lib,
  ...
}:
{
  programs.git = {
    enable = true;
    userName = "Aubrey Taylor";
    userEmail = "aubrey@hall.ly";

    lfs.enable = true;

    extraConfig = {
      gpg.format = "ssh";
      "gpg \"ssh\"".program = "${lib.getExe' pkgs._1password-gui "op-ssh-sign"}";
      commit.gpgsign = true;
      user.signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJZn43IczAtHI49eULTaA3GY7Zdoy/gqeEIhev/3ub09";
      init.defaultBranch = "main";
      pull.rebase = true;
    };
  };
}
