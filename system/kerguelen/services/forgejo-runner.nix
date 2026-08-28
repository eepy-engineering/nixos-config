{ pkgs, ... }: {
  virtualisation.docker.enable = true;
  opnix.secrets = [
    {
      path = "forgejo/token";
      reference = "op://Services/Codeberg Runner/password";
    }
  ];
  services.forgejo-runner.instances = {
    hakkun = {
      settings = {
        runner.labels = [ "alpine:docker://docker.io/fruityloops1/alpine-hakkun:latest" ];
        server.connections = {
          codeberg = {
            uuid = "212df6d6-4af2-4dee-ab32-607af7fea60a";
            url = "https://codeberg.org/";
            token_url = pkgs.asOpnixPath "forgejo/token";
          };
        };
      };
    };
  };
}
