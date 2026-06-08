{ pkgs, ... }:
{
  documentation.dev.enable = true;

  environment.systemPackages = with pkgs; [
    man-pages
    man-pages.out
    man-pages-posix
    # manpages-l10n
  ];

  i18n = {
    extraLocaleSettings = {
      LC_MESSAGES = "de_DE.UTF-8";
    };
  };
}
