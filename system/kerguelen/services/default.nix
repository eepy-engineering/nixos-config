{
  imports = [
    # top level services
    ./dns.nix
    ./nginx.nix
    ./forgejo-runner.nix
    # containers
    ./firefly-iii
    ./teamspeak
    ./traccar
    ./smo-wiki.nix
  ];
}
