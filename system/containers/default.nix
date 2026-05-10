{
  pkgs,
  hostName,
  ...
}:
{
  opnix = {
    secrets = [
      {
        path = "smo-wiki/webhook";
        reference = "op://Services/SMO.wiki Discord Webhook/password";
      }
      {
        path = "smo-wiki/admin-password";
        reference = "op://Services/SMO.wiki admin/password";
      }
      {
        path = "smo-wiki/cloudflared.pem";
        reference = "op://Services/h3ewjwxbus3gops6qi4naiwpn4/notesPlain";
      }
      {
        path = "smo-wiki/tunnel.json";
        reference = "op://Services/ty24aofrqct3solie6v2iv7fke/notesPlain";
      }
    ];
    services = [ "container@smo-wiki.service" ];
  };
  containers = {
    smo-wiki = rec {
      autoStart = hostName == "puppygirl";
      privateNetwork = false;
      bindMounts = {
        ${pkgs.asOpnixPath "smo-wiki"} = {
          hostPath = pkgs.asOpnixPath "smo-wiki";
          isReadOnly = true;
        };
      };
      config = {
        imports = [ ./smo-wiki ];
        nixpkgs.pkgs = pkgs;
      };
    };
  };
}
