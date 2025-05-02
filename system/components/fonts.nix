{pkgs, ...}: {
  fonts = {
    fontconfig.useEmbeddedBitmaps = true;
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      liberation_ttf
      (nerdfonts.override {fonts = ["FiraCode"];})
      fira-code
      fira-code-symbols
      mplus-outline-fonts.githubRelease
      dina-font
      proggyfonts
      comic-mono
    ];
  };
}
