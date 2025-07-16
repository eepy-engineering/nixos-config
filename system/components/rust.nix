{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    fenix.stable.completeToolchain
    rust-analyzer-nightly
  ];
}
