{
  imports = [
    # root containers
    ./dns.nix
    ./nginx.nix
    # containers
    ./firefly-iii
    ./traccar
    ./smo-wiki.nix
  ];
}
