{ pkgs, inputs, ... }:
{
  fonts = {
    packages = with pkgs; [
      # normal text
      noto-fonts
      noto-fonts-color-emoji
      # mono
      comic-mono
      inputs.tetra-config.packages.${pkgs.stdenv.hostPlatform.system}.klee-one
      # toki pona
      nasin-nanpa-ucsur
      nasin-nanpa-helvetica
    ];
  };
}
