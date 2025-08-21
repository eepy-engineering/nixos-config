{pkgs, ...}: {
  # deprecated: declarative wireless
  # if you have no internet access, you might not be able to add new networks.
  # this is too inconvenient.
  # networking.wireless = {
  #   enable = true;
  #   userControlled.enable = true;
  #   secrets = {
  #     homePsk = "op://Services/tfohn2xlz72a75pmhl3k26wcou/password";
  #     hotspotPsk = "op://Services/dspuw2m3qpcrmefgzdcqliieiy/password";
  #   };
  #   networks = {
  #     "Private Network".pskRaw = "ext:homePsk";
  #     "nn::oe::FinishStartupLogo".pskRaw = "ext:hotspotPsk";
  #   };
  # };
}
