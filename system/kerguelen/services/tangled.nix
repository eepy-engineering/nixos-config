{
  config,
  lib,
  self,
  ...
}:
let
  cfg = config.services.tangled.knot;
in
{
  services = {
    tangled = {
      knot = {
        enable = true;
        gitUser = "git";
        stateDir = "/var/lib/tangled-knot";
        repo.scanPath = "${cfg.stateDir}/repos";
        server = {
          listenAddr = "0.0.0.0:3002";
          hostname = "sanae6.ca";
          internalListenAddr = "127.0.0.1:3003";
          owner = "did:plc:wylibiungpfmooaz6ld5fdbg";
        };
      };
      spindle = {
        enable = false;
        server = {
          listenAddr = "0.0.0.0:3004";
          hostname = "sanae6.ca";
          owner = "did:plc:wylibiungpfmooaz6ld5fdbg";
        };
        pipelines.workflowTimeout = "10m";
      };
    };
    openssh = {
      settings.AllowUsers = [ "git" ];
      settings.AllowGroups = [ "git" ];
    };
  };
}
