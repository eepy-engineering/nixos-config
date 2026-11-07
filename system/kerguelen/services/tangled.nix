{ inputs, ... }: {
  imports = [
    inputs.tangled.nixosModules.knot-rs
    inputs.tangled.nixosModules.spindle
  ];
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
            hostname = "knot.sanae6.ca";
            admins = [ "did:plc:wylibiungpfmooaz6ld5fdbg" ];
            listen_addr = "[::]:3002";
            ssh_listen_addr = "[::]:2223";
          };
          git.object_format = "sha1"; # most tools are not ready for this yet
          repo.scan_path = "/persist/git";
          lfs.store_path = "/persist/tangled/lfs";
          atproto.plc_directory = "https://plc.directory";
          http.block_private_addresses = false;
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
  };
}
