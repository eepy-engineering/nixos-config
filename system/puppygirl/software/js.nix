{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    pnpm
    nodejs
  ];
}
