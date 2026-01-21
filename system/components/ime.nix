{
  pkgs,
  isDesktop,
  ...
}:
{
  i18n.inputMethod = {
    enable = false;
    type = "fcitx5";
    fcitx5 = {
      waylandFrontend = true;
      addons = with pkgs; [
        fcitx5-mozc
        fcitx5-table-other
      ];
    };
  };
}
