{ pkgs, ... }:
{
  services =
    let
      service = {
        enable = true;
        group = "media";
      };
    in
    {
      sonarr = service;
      lidarr = service;
      radarr = service;
      bazarr = service;

      jackett = service;
    };
}
