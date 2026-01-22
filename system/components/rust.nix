{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    fenix.stable.toolchain
    fenix.beta.rust-analyzer
  ];
}
