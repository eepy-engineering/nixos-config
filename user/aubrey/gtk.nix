{ pkgs, isDesktop, ... }: {
  gtk = {
    enable = isDesktop;

    iconTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };
  };
}
