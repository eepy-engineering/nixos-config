{ pkgs, ... }:
{

  hardware.opentabletdriver = {
    enable = true;
    # package = pkgs.opentabletdriver.overrideAttrs (prev: {
    #   patches = [ ./H641P-aux.patch ];
    # });
  };
}
