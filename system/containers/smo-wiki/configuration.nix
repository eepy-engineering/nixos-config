{
  lib,
  pkgs,
  config,
  site,
  cloudflaredTunnelId,
  galeraName,
  readOnly,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    dig
    neovim
    socat
  ];

  services = {
    mediawiki = {
      enable = true;
      database.createLocally = true;
      phpPackage = pkgs.php83;

      passwordSender = "supermarioodysseywiki@gmail.com";
      passwordFile = pkgs.asOpnixPath "smo-wiki/admin-password";
      extensions = {
        "AbuseFilter" = null;
        "CategoryTree" = null;
        "ChangeAuthor" = pkgs.fetchgit {
          url = "https://gerrit.wikimedia.org/r/mediawiki/extensions/ChangeAuthor";
          rev = "122d33c4a302e30035c1b958306cea61c4621994";
          sha256 = "sha256-AtbB/kOqZLOKyY+gqoYExOtS6rNQ6rzcAM7LugWE6ig=";
        };
        "Cite" = null;
        "Comments" = pkgs.fetchgit {
          url = "https://gerrit.wikimedia.org/r/mediawiki/extensions/Comments";
          rev = "161348fb15d63a239e95dbb67a4f08318d8000e3"; # master
          sha256 = "sha256-Oq+MvCpNSUzBm/ulD453MmhLHQsqqOV7Z40tPko+ldM=";
        };
        "ConfirmEdit/Turnstile" = null;
        "CodeEditor" = null;
        "CodeMirror" = pkgs.fetchgit {
          url = "https://gerrit.wikimedia.org/r/mediawiki/extensions/CodeMirror";
          rev = "bfd93266efcfabf59062ae09ba54afe41b165e9d";
          hash = "sha256-aNLnEnqBip7VmE+8CIyJFOY1AI6AHTqcZpw3V8hEAhk=";
        };
        # "DarkMode" = pkgs.fetchgit {
        #   url = "https://gerrit.wikimedia.org/r/mediawiki/extensions/DarkMode";
        #   rev = "ab2578451d5fc99007cd019d174d79c5a8b13aaf";
        #   sha256 = "sha256-PjPj9k5aLh1jN/xcVOTGByrFA+NXQgz9oIioJnOJUf4=";
        # };
        "Diagrams" = pkgs.fetchFromGitHub {
          owner = "Sanae6";
          repo = "diagrams-extension";
          rev = "cd6a967bd3b59321a81e780db95d822a49cb5970";
          hash = "sha256-8AVMz7xTgZbeneBwkdEJ7CziROgMnA4o/3q4cEDCxqc=";
        };
        "DiscordNotifications" = pkgs.fetchzip {
          url = "https://github.com/miraheze/DiscordNotifications/archive/997d64722dcd0697d002612d9b890e3c0e3e1906.zip";
          sha256 = "sha256-yJaCcq1S8sRLnnlswy0R5Nv/j2ZboLLdKxoOtMjp2BM=";
        };
        "EmbedVideo" = pkgs.fetchzip {
          url = "https://github.com/StarCitizenWiki/mediawiki-extensions-EmbedVideo/archive/refs/tags/v4.0.0.zip";
          sha256 = "sha256-NheTJxhXkogQutWsy8Ukfvjrh5jePv+bpeFs1V1kf1w=";
        };

        "Math" = null;
        "MobileFrontend" = pkgs.fetchgit {
          url = "https://gerrit.wikimedia.org/r/mediawiki/extensions/MobileFrontend";
          rev = "899edb9ee5c7f572c4e1e5b600d3085f7229c9f7";
          sha256 = "sha256-tJKOZux/WyvGDJMa6q+KO0YWT3wyRj2vzaLUwtGVm+0=";
        };
        "Nuke" = pkgs.fetchgit {
          url = "https://gerrit.wikimedia.org/r/mediawiki/extensions/Nuke";
          rev = "2774fccbe931c1041c2268942aff27db7eb34637";
          sha256 = "sha256-rpDpl31eGO+DAiINjWhXWY2FyxQuHRSVLDQ5sA/MM7Y=";
        };
        "NiceCategoryList3" = pkgs.fetchFromGitHub {
          owner = "JLTRY";
          repo = "NiceCategoryList3";
          rev = "686ac89bff8871c59dd27032366248ef3649a3ce";
          hash = "sha256-Hw+78yWIVIX0N/Nf1MfT/I5v95WUHyvwCzuczvDZku8=";
        };
        "PageImages" = null;
        "ParserFunctions" = null;
        "Popups" = pkgs.fetchgit {
          url = "https://gerrit.wikimedia.org/r/mediawiki/extensions/Popups";
          rev = "8b08548aecd5989a69ce002bdcd7c0c719cde30d";
          sha256 = "sha256-VafVhmRGL5cSAFawg/GL4erz9T92zwpVM57omEeC/0Q=";
        };
        "SaneCase" = pkgs.fetchzip {
          url = "https://github.com/ciencia/mediawiki-extensions-SaneCase/archive/e956ed69fcb8a1c6b4f0fef7ce64400e259c6c56.zip";
          sha256 = "sha256-ICdiiSe7jvo00RuxtuVuipWSHU5UQmi11FKo4kDBMRI=";
        };
        "Scribunto" = null;
        "StopForumSpam" = pkgs.fetchgit {
          url = "https://gerrit.wikimedia.org/r/mediawiki/extensions/StopForumSpam";
          rev = "24fa50804b7cf915756f48cf57f983982d0e0e89";
          sha256 = "sha256-4AP5mS0HOvsdeiBR0mQOUOg686sBiFwRDvurDn4PiqA=";
        };
        "StubUserWikiAuth" = pkgs.fetchzip {
          url = "https://github.com/ciencia/mediawiki-extensions-StubUserWikiAuth/archive/020e411ee2e794faecc0db471ce433d02936e8a0.zip";
          sha256 = "sha256-tfnU+p5GDGeb6iJ5zt/UoeCdgD6zS1VGDq8fDje8ALk=";
        };
        "TextExtracts" = null;
        "TimedMediaHandler" = pkgs.fetchgit {
          url = "https://gerrit.wikimedia.org/r/mediawiki/extensions/TimedMediaHandler";
          rev = "264a0c96bb456ed162dcb5d001bc48876ceda21b";
          sha256 = "sha256-OSpmRogd2UEXFMQz2bEfj6tLEe9OPX+tB82hZZElQrY=";
        };
        "TitleBlacklist" = null;
        "Translate" = pkgs.fetchgit {
          url = "https://gerrit.wikimedia.org/r/mediawiki/extensions/Translate";
          rev = "c5f12bdf434878471c9b3f2f86e8604c389f8b12";
          hash = "sha256-2KTdgVWT7lzMUBQPld0jA5jLtwb9nBzO0CoCoDA4slc=";
        };
        "UniversalLanguageSelector" = pkgs.fetchgit {
          url = "https://gerrit.wikimedia.org/r/mediawiki/extensions/UniversalLanguageSelector";
          rev = "86340981f2cd44bb2f8170b2a7bae9f54763a5f9";
          hash = "sha256-P6VtMoE2fm4aAqXvKB3BDoqxiJvWwXxum9zem/wg4Lo=";
        };
        "VisualEditor" = null;
        "Widgets" = pkgs.symlinkJoin {
          name = "widgets-smarty";
          paths = [
            (pkgs.fetchgit {
              url = "https://gerrit.wikimedia.org/r/mediawiki/extensions/Widgets";
              rev = "f7cdd56fa33f5bdedc659ed57bb88f52fb6a8b49";
              sha256 = "sha256-Xhd1WtWMvOyuDeKgw/GCs6jYNt2LJBHY7TyTCW0doNA=";
            })
            (pkgs.writeTextFile {
              name = "autoload.php";
              destination = "/vendor/autoload.php";
              text = ''<?php include "${pkgs.smarty3}/Smarty.class.php" ?>'';
            })
          ];
          postBuild = ''
            rm -r $out/compiled_templates
            ln -s /var/cache/mediawiki/compiled_templates $out/compiled_templates
          '';
        };
        "WikiEditor" = null;
      };

      skins = {
        "MinervaNeue" = "${config.services.mediawiki.package}/share/mediawiki/skins/MinervaNeue";
      };
      extraConfig = ''
        include "${pkgs.asOpnixPath "smo-wiki/secure-settings.php"}";
        ${builtins.readFile ./LocalSettings.php}
        ${if readOnly != null then ''$wgReadOnly = "${readOnly}";'' else ""}
        $wgDiff3 = "${pkgs.diffutils}/bin/diff3";
        $wgSVGConverters = [ 'rsvg' => '${pkgs.librsvg}/bin/rsvg-convert -w $width -h $height -o $output $input' ];
        $wgImageMagickConvertCommand = "${pkgs.imagemagick}/bin/convert";
        $wgDiagramsLocalCommands = [
          "dot"   => "${pkgs.graphviz}/bin/dot",
          "neato" => "${pkgs.graphviz}/bin/neato",
          "fdp"   => "${pkgs.graphviz}/bin/fdp",
          "sfdp"  => "${pkgs.graphviz}/bin/sfdp",
          "circo" => "${pkgs.graphviz}/bin/circo",
          "twopi" => "${pkgs.graphviz}/bin/twopi",
        ];
      '';
      path = with pkgs; [
        diffutils
        imagemagick
        librsvg
        curl
      ];
      webserver = "nginx";
      nginx = {
        hostName = site;
      };
    };

    nginx.virtualHosts.${site} = {
      listenAddresses = [ "unix:/run/nginx/nginx.sock" ];
      locations = {
        "~ ^/static/(.+)$" = {
          alias = "${./static}/$1";
        };
        "/".extraConfig = lib.mkForce ''
          rewrite ^/(?<pagename>.*)$ /w/index.php;
        '';
        "/mediawiki".extraConfig = ''
          rewrite ^/mediawiki/(.*)$ /w/$1 permanent;
        '';
        "= /robots.txt" = {
          alias = ./robots.txt;
        };
        "= /favicon.ico" = {
          alias = ./static/logo-144x144.png;
        };
        "= /Home" = {
          return = "301 /";
        };
        "= /".extraConfig = lib.mkForce ''
          rewrite ^/(?<pagename>.*)$ /w/index.php;
        '';
      };
      extraConfig = ''
        set_real_ip_from unix:;
        real_ip_header CF-Connecting-IP;
      '';
    };

    mysql = {
      enable = true;
      package = pkgs.mariadb;
      dataDir = "/mnt/mysql";
      settings = {
        mysqld = {
          skip-networking = true;
          log-error = "${config.services.mysql.dataDir}/mysql_err.log";
          # wsrep_provider_options = ["pc.weight=2"];
          plugin-wsrep-provider = true;
          binlog_format = "ROW";
          default_storage_engine = "InnoDB";
          innodb_autoinc_lock_mode = 2;
        };
      };
      ensureUsers = [
        {
          name = "root";
          ensurePermissions = {
            "mediawiki.*" = "ALL PRIVILEGES";
          };
        }
      ];
      galeraCluster = {
        enable = true;
        package = pkgs.mariadb-galera;
        nodeAddresses = [
          "kokuzo.tailc38f.ts.net"
          "kerguelen.tail6c2ee5.ts.net"
        ];
        localName = galeraName;
        name = "smowiki";
      };
    };

    mysqlBackup = {
      enable = true;
      databases = [
        "mediawiki"
      ];
      location = "/mnt/backup-mysql";
      calendar = "Mon";
      singleTransaction = true;
    };

    syncthing = {
      enable = true;
      user = "mediawiki";
      group = config.users.users.mediawiki.group;
      guiAddress = "${galeraName}:8384";
      cert = pkgs.asOpnixPath "smo-wiki/syncthing-cert.pem";
      key = pkgs.asOpnixPath "smo-wiki/syncthing-key.pem";
      settings = {
        devices = {
          kokuzo = {
            id = "LWMJKAA-J7SJBGZ-RXHPDUX-WASDYT7-KKQPOUN-YZB2KTD-ZFKNLOX-IAQBQQY";
            addresses = [
              "tcp://kokuzo.tailc38f.ts.net"
            ];
          };
          kerguelen = {
            id = "ACATTSC-A3OPS5T-UHMYFBP-5DKVSQP-25U6Y4I-ZBNWAMR-OGNW4MA-U6WBWQG";
            addresses = [
              "tcp://kerguelen.tail6c2ee5.ts.net"
            ];
          };
        };
        folders = {
          "Mediawiki" = {
            label = "Mediawiki";
            path = "/var/lib/mediawiki";
            devices = [
              "kokuzo"
              "kerguelen"
            ];
          };
        };
      };
    };

    cloudflared = {
      enable = true;
      certificateFile = pkgs.asOpnixPath "smo-wiki/cloudflared.pem";
      tunnels = {
        ${cloudflaredTunnelId} = {
          credentialsFile = pkgs.asOpnixPath "smo-wiki/tunnel.json";
          default = "http_status:404";
          ingress = {
            ${site} = "unix:/run/nginx/nginx.sock";
          };
        };
      };
    };
  };

  systemd = {
    services = {
      "cloudflared-tunnel-${cloudflaredTunnelId}" = {
        serviceConfig = {
          SupplementaryGroups = [ config.services.nginx.group ];
          BindPaths = "/run/nginx";
        };
      };
      mysql = {
        serviceConfig = {
          TimeoutSec = 900;
        };
      };
      ip-list-refresh = {
        requires = [
          "network-online.target"
        ];
        requiredBy = [ "nginx.service" ];
        path = with pkgs; [
          wget
          unzip
        ];
        script = ''
          wget -O /tmp/listed_ip.zip https://www.stopforumspam.com/downloads/listed_ip_30_all.zip
          unzip -ud /var/lib/mediawiki/ /tmp/listed_ip.zip
        '';
        serviceConfig = {
          Type = "oneshot";
        };
      };
      mediawiki-job-queue = {
        path = [
          (lib.findFirst (pk: pk.name == "mediawiki-scripts") null config.environment.systemPackages)
        ];
        script = ''
          mediawiki-maintenance runJobs --maxtime 3600
        '';
        serviceConfig = {
          PrivateTmp = true;
          Type = "oneshot";
          User = "mediawiki";
        };
      };
    };
    timers = {
      ip-list-refresh = {
        wantedBy = [ "timers.target" ];
        requires = [ "network-online.target" ];
        timerConfig = {
          OnCalendar = "00:00:00";
          Persistent = true;
          Unit = [ "ip-list-refresh.service" ];
        };
      };
      mediawiki-job-queue = {
        wantedBy = [ "timers.target" ];
        timerConfig = {
          OnCalendar = "hourly";
          Persistent = true;
          Unit = [ "mediawiki-job-queue.service" ];
        };
      };
    };
  };

  system.activationScripts = {
    create-nginx-dir.text = ''
      mkdir /run/nginx
      chown ${config.services.nginx.user}:${config.services.nginx.group} /run/nginx
      chmod 1750 /run/nginx
    '';
    cached-compiled-templates.text = ''
      mkdir -p /var/cache/mediawiki/compiled_templates
      chown mediawiki:nginx /var/cache/mediawiki/compiled_templates
      chmod 700 /var/cache/mediawiki/compiled_templates
    '';
    secrets.text = ''
      mkdir -p ${pkgs.asOpnixPath ""}
      cp -r /mnt/opnix/* ${pkgs.asOpnixPath ""}
      chmod -R 777 ${pkgs.asOpnixPath ""}
    '';
  };
  system.stateVersion = "26.05";
}
