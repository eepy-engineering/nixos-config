{ pkgs, ... }: {
  virtualisation.docker.enable = true;
  opnix = {secrets = [
    {
      path = "forgejo/sanae6-token";
      reference = "op://Services/Codeberg Runner - Sanae6/password";
    }
    {
      path = "forgejo/senobinx-token";
      reference = "op://Services/Codeberg Runner - SenobiNX/password";
    }
  ];
  services = ["forgejo-runner-hakkun.service"];
  };
  services.forgejo-runner.instances = {
    hakkun = {
      enable = true;
      settings = {
        runner.labels = [ "alpine:docker://docker.io/fruityloops1/alpine-hakkun:latest" ];
        server.connections = {
          sanae6 = {
            uuid = "212df6d6-4af2-4dee-ab32-607af7fea60a";
            url = "https://codeberg.org/";
          };
          senobinx = {
            uuid = "64fe36e5-e6fa-4882-9764-a150b8198ff8";
            url = "https://codeberg.org/";
          };
        };
      };
      secrets.server.connections = {
        sanae6.token_url = pkgs.asOpnixPath "forgejo/sanae6-token";
        senobinx.token_url = pkgs.asOpnixPath "forgejo/senobinx-token";
      };
    };
  };
}
