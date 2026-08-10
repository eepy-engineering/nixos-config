{
  imports = [
    # root containers
    ./dns.nix
    ./nginx.nix
    # containers
    ./firefly-iii
    ./teamspeak
    ./traccar
    ./smo-wiki.nix
  ];
}
