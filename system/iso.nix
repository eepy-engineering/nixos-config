{ config, pkgs, ... }:
{
  imports = [
    <nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix>

    # Provide an initial copy of the NixOS channel so that the user
    # doesn't need to run "nix-channel --update" first.
    <nixpkgs/nixos/modules/installer/cd-dvd/channel.nix>
  ];
  # Enable SSH in the boot process.
  environment.systemPackages = with pkgs; [ neovim ];
  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "yes";
  };
  systemd.services.sshd.wantedBy = pkgs.lib.mkForce [ "multi-user.target" ];
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJZn43IczAtHI49eULTaA3GY7Zdoy/gqeEIhev/3ub09"
  ];

  services.tailscale.enable = true;
}
