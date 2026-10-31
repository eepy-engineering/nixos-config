{
  config,
  lib,
  self,
  ...
}:
let
  cfg = config.services.tangled.knot-rs;
in
{
  users = {
    users.git.uid = 504;
    groups.git.gid = 504;
  };
  services = {
    tangled = {
      knot-rs = {
        enable = true;
        user = "git";
        group = "git";
        stateDir = "/persist/tangled";
        environmentFile = "/persist/tangled/knot.env";
        settings = {
          server = {
            hostname = "sanae6.ca";
            admins = [ "did:plc:wylibiungpfmooaz6ld5fdbg" ];
            ssh_listen_addr = "[::]:2223";
          };
          repo.scan_path = "/persist/git";
          lfs.store_path = "/persist/tangled/lfs";
          atproto.plc_directory = "https://plc.directory";
          contact = {
            email = "aubrey@sanae6.ca";
          };
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
      settings.AllowUsers = [
        "git"
        "aubrey"
      ];
      settings.AllowGroups = [ "git" "users" ];
    };
  };
}
