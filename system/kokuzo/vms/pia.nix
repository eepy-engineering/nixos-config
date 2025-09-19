{
  lib,
  pkgs,
  ...
}:
{
  imports = [
    # ./seedbox.nix
    ../../components/credentials.nix
    ../../components/network-connected.nix
    ../../components/pia
  ];

  environment.systemPackages = with pkgs; [
    speedtest-cli
    nftables
    dig
  ];

  services.pia-vpn.region = "ca_toronto";

  systemd.services = {
    tailscaled-autoconnect = {
      after = [
        "network-connected.service"
        "wg-pia-setup.service"
      ];
    };
    tailscaled-set = {
      after = [
        "network-connected.service"
        "wg-pia-setup.service"
      ];
    };
    tailscaled = {
      after = [ "wg-pia-setup.service" ];
    };
  };

  opnix = {
    secrets = [
      {
        path = "tailscale/authKey";
        reference = "op://Services/a3rsm553bty6eec24l6j6se6re/credential";
      }
    ];
    users = [ ];
    services = [ "tailscaled-autoconnect.service" ];
  };

  services.tailscale = {
    enable = true;
    extraUpFlags = [
      "--advertise-tags=tag:nixos"
      "--advertise-exit-node"
      "--netfilter-mode=off"
    ];
    authKeyFile = pkgs.asOpnixPath "tailscale/authKey";
    authKeyParameters.preauthorized = true;
    useRoutingFeatures = "both";
  };

  networking = {
    hostName = "pia";
    firewall.enable = false;

    useHostResolvConf = lib.mkForce false;

    useDHCP = false;
    useNetworkd = false;
  };

  microvm = {
    interfaces = [
      {
        type = "tap";
        id = "vm-pia";
        mac = "02:00:00:00:00:01";
      }
    ];

    shares = [
      {
        tag = "ro-store";
        source = "/nix/store";
        mountPoint = "/nix/.ro-store";
        proto = "virtiofs";
      }
      {
        tag = "opnix-token";
        source = "/var/opnix-token";
        mountPoint = "/var/opnix-token";
        proto = "virtiofs";
      }
    ];
  };

  systemd.network.enable = true;

  systemd.network.networks."20-lan" = {
    matchConfig.Type = "ether";
    networkConfig = {
      Address = [
        "192.168.3.1/24"
        "2001:db8::b/64"
      ];
      Gateway = "192.168.1.1";
      DNS = [ "192.168.1.1" ];
      IPv6AcceptRA = true;
      DHCP = "no";
    };
  };

  services.resolved.enable = true;

  # no change don't change do not change
  system.stateVersion = "25.05"; # very no touchy
  # no change don't change do not change
}
