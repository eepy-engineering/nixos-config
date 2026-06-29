{ ... }:
{
  services.openssh = {
    enable = true;

    settings = {
      X11Forwarding = true;
      UsePAM = true;
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  programs.ssh.knownHostsFiles = [
    # Personal Servers
    # ./known-hosts/kerguelen
    ./known-hosts/rose-desktop
    ./known-hosts/kokuzo

    # Organizations
    ./known-hosts/github.com

    # Public Projects
    ./known-hosts/wolfgirl.systems
    ./known-hosts/terminal.shop
  ];
}
