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
      jetbrains-mono
      # toki pona
      nasin-nanpa-ucsur
      nasin-nanpa-helvetica
    ];

    fontconfig = {
      enable = true;
      localConf = ''
        <fontconfig>
          <match target="pattern">
            <edit name="family" mode="prepend_first">
              <string>nasin-nanpa</string>
            </edit>
          </match>
        </fontconfig>
      '';
      defaultFonts = {
        serif = [
          "nasin-nanpa"
          "nasin\\-nanpa"
          "Noto Serif"
          "Klee One"
          "Helvetica"
        ];
        sansSerif = [
          "nasin-nanpa"
          "nasin\\-nanpa"
          "Noto Sans"
          "Klee One"
          "Helvetica"
        ];
        monospace = [
          "nasin-nanpa"
          "nasin\\-nanpa"
          "Comic Mono"
          "Klee One"
          "JetBrainsMonoNL"
        ];
      };
    };
  };
}
