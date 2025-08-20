{isDesktop, ...}: {
  services = {
    flameshot = {
      enable = isDesktop;
      settings = {
        General = {
          showHelp = false;
          showSidePanelButton = false;
          showDesktopNotification = false;
          disabledGrimWarning = true;
        };
      };
    };
  };
}
