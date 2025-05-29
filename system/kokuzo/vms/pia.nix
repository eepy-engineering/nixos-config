{
  lib,
  pkgs,
  ...
}: {
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
      after = ["network-connected.service" "wg-pia-setup.service"];
    };
    tailscaled-set = {
      after = ["network-connected.service" "wg-pia-setup.service"];
    };
    tailscaled = {
      after = ["wg-pia-setup.service"];
    };
  };

  opnix = {
    secrets = [
      {
        path = "tailscale/authKey";
        reference = "op://Services/a3rsm553bty6eec24l6j6se6re/credential";
      }
    ];
    users = [];
    services = ["tailscaled-autoconnect.service"];
  };

  services.tailscale = {
    enable = true;
    extraUpFlags = ["--advertise-tags=tag:nixos" "--advertise-exit-node" "--netfilter-mode=off"];
    authKeyFile = pkgs.asOpnixPath "tailscale/authKey";
    authKeyParameters.preauthorized = true;
    useRoutingFeatures = "both";
  };

  networking = {
    hostName = "pia";
    firewall.enable = false;

    useHostResolvConf = lib.mkForce false;
  };

  services.resolved.enable = true;

  # no change don't change do not change
  system.stateVersion = "24.11"; # very no touchy
  # no change don't change do not change
}
