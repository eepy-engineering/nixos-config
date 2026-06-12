{
  pkgs,
  isDesktop,
  ...
}:
{
  home.packages =
    with pkgs;
    if isDesktop then
      [
        zen-browser
      ]
    else
      [ ];

  xdg.mimeApps = {
    enable = isDesktop;
    defaultApplications = {
      "text/html" = "zen.desktop";
      "application/pdf" = "zen.desktop";
      "x-scheme-handler/http" = "zen.desktop";
      "x-scheme-handler/https" = "zen.desktop";
      "x-scheme-handler/about" = "zen.desktop";
      "x-scheme-handler/unknown" = "zen.desktop";
    };
  };
}
