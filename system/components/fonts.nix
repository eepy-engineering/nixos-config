{ pkgs, ... }:
{
  fonts = {
    fontconfig.useEmbeddedBitmaps = true;
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      liberation_ttf
      nerd-fonts.fira-code
      nerd-fonts.iosevka
      fira-code
      fira-code-symbols
      mplus-outline-fonts.githubRelease
      dina-font
      proggyfonts
      nerd-fonts.comic-shanns-mono
      nerd-fonts.jetbrains-mono
      comic-mono
      iosevka
      inter
    ];
  };
}
