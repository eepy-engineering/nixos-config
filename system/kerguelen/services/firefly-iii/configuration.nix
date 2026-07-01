{
  pkgs,
  lib,
  ...
}:
{
  networking = {
    firewall.enable = false;
    # Use systemd-resolved inside the container
    # Workaround for bug https://github.com/NixOS/nixpkgs/issues/162686
    useHostResolvConf = lib.mkForce false;
  };

  services.firefly-iii = {
    enable = true;
    dataDir = "/mnt/firefly-iii";
    user = "firefly-iii";

    settings = {
      APP_ENV = "production";
      APP_KEY_FILE = "/mnt/firefly-iii/key-file";
      SITE_OWNER = "aubrey@sanae6.ca";
      DB_CONNECTION = "mysql";
      DB_HOST = "localhost";
      DB_DATABASE = "firefly";
      DB_USERNAME = "firefly-iii";
      DB_SOCKET = "/run/mysqld/mysqld.sock";
    };
    enableNginx = true;
  };

  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
    dataDir = "/mnt/firefly-iii/mariadb";
    user = "firefly-iii";
    ensureUsers = [
      {
        name = "firefly-iii";
        ensurePermissions = {
          "firefly.*" = "ALL PRIVILEGES";
        };
      }
    ];
    ensureDatabases = [ "firefly" ];
    settings = {
      mysqld = {
        skip-networking = true;
      };
    };
  };

  users = {
    users.firefly-iii = {
      uid = 501;
    };
  };

  system.stateVersion = "26.11";
}
