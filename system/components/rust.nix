{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    fenix.stable.toolchain
    rust-analyzer-nightly
  ];
}
