{
  imports = [
    # top level services
    ./dns.nix
    ./nginx.nix
    ./forgejo-runner.nix
    ./bsky-pds.nix
    ./tangled.nix
    # containers
    ./firefly-iii
    ./forgejo
    ./teamspeak
    ./traccar
    ./smo-wiki.nix
  ];
}
