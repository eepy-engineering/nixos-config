{
  pkgs,
  lib,
  config,
  ...
}:
let
  ot-config = {
    OTR_STORAGEDIR = "/mnt/owntracks/recorder";
    OTR_HOST = "localhost";
    OTR_HTTPHOST = "0.0.0.0";
    OTR_HTTPPORT = 8083;
    OTR_TOPICS = "owntracks/#";
  };
in
{
  networking = {
    firewall.allowedTCPPorts = [
      (builtins.head config.services.mosquitto.listeners).port
      ot-config.OTR_HTTPPORT
    ];
    firewall.enable = false;

    # Use systemd-resolved inside the container
    # Workaround for bug https://github.com/NixOS/nixpkgs/issues/162686
    useHostResolvConf = lib.mkForce false;
  };

  services.httpd = {
    enable = true;
    adminAddr = "admin@example.org";
  };

  services = {
    resolved.enable = true;
    mosquitto = {
      enable = true;
      listeners = [
        {
          address = "0.0.0.0";
          port = 1883;
          acl = [ "pattern readwrite #" ];
          omitPasswordAuth = true;
          settings.allow_anonymous = true;
        }
      ];
    };
  };

  environment.systemPackages = with pkgs; [
    owntracks-recorder
    mosquitto
  ];

  users = {
    users.owntracks = {
      isSystemUser = true;
      group = "owntracks";
    };
    groups.owntracks = { };
  };

  environment.etc = {
    ot-recorder = {
      text = lib.generators.toKeyValue {
        mkKeyValue = lib.generators.mkKeyValueDefault {
          mkValueString = v: if lib.isString v then ''"${v}"'' else lib.generators.mkValueStringDefault { } v;
        } "=";
      } ot-config;
      target = "default/ot-recorder";
      mode = "0440";
      user = "owntracks";
      group = "owntracks";
    };
  };

  systemd.services = {
    owntracks-recorder = {
      description = "OwnTracks Recorder";
      wants = [
        "mosquitto.service"
      ];
      after = [
        "mosquitto.service"
      ];
      wantedBy = [
        "multi-user.target"
      ];

      serviceConfig = {
        Type = "simple";
        User = "owntracks";
      };
      preStart = "${pkgs.owntracks-recorder}/bin/ot-recorder --initialize";
      script = "${pkgs.owntracks-recorder}/bin/ot-recorder";
    };
  };

  system.stateVersion = "26.11";
}
