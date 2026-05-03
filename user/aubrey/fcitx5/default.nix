{
  pkgs,
  isDesktop,
  ...
}:
{
  i18n.inputMethod = {
    enable = isDesktop;
    type = "fcitx5";
    fcitx5 = {
      waylandFrontend = false;
      addons = with pkgs; [
        fcitx5-mozc
        qt6Packages.fcitx5-chinese-addons # this is required for the table addon, thanks nixpkgs :(
        fcitx5-table-other
        fcitx5-table-extra
        kdePackages.fcitx5-qt
        kdePackages.fcitx5-configtool
        ilo-sitelen
        fcitx5-m17n
        fcitx-passthrough
      ];
    };
  };
  home.packages = [
    pkgs.m17n_db
  ];
}
