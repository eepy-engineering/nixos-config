{ isDesktop, ... }:
{
  programs.vesktop = {
    enable = isDesktop;
    settings = {
      discordBranch = "canary";
      minimizeToTray = true;
      arRPC = true;
      splashTheming = true;
      splashColor = "rgb(219, 220, 223)";
      splashBackground = "rgb(12, 12, 14)";
      spellCheckLanguages = [
        "en-US"
        "us"
      ];
      customTitleBar = false;
      enableMenu = false;
      staticTitle = false;
    };
  };
}
