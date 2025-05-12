{
  pkgs,
  isDesktop,
  ...
}: {
  i18n.inputMethod = {
    enable = isDesktop;
    type = "fcitx5";
    fcitx5 = {
      waylandFrontend = true;
      addons = with pkgs; [
        fcitx5-mozc
        kdePackages.fcitx5-qt
        kdePackages.fcitx5-configtool
      ];
    };
  };
}
