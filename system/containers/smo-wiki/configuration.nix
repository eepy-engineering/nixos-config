{
  lib,
  pkgs,
  config,
  site,
  shouldBackup,
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
        "Cite" = null;
        # "ConfirmEdit" = null;
        # "ConfirmEdit/QuestyCaptcha" = null;
        "ConfirmEdit/Turnstile" = null;
        "ChangeAuthor" = pkgs.fetchgit {
          url = "https://gerrit.wikimedia.org/r/mediawiki/extensions/ChangeAuthor";
          rev = "122d33c4a302e30035c1b958306cea61c4621994";
          sha256 = "sha256-AtbB/kOqZLOKyY+gqoYExOtS6rNQ6rzcAM7LugWE6ig=";
        };
        "DarkMode" = pkgs.fetchgit {
          url = "https://gerrit.wikimedia.org/r/mediawiki/extensions/DarkMode";
          rev = "ab2578451d5fc99007cd019d174d79c5a8b13aaf";
          sha256 = "sha256-PjPj9k5aLh1jN/xcVOTGByrFA+NXQgz9oIioJnOJUf4=";
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
        $wgDiff3 = "${pkgs.diffutils}/bin/diff3";
        $wgSVGConverters = [ 'rsvg' => '${pkgs.librsvg}/bin/rsvg-convert -w $width -h $height -o $output $input' ];
        $wgImageMagickConvertCommand = "${pkgs.imagemagick}/bin/convert";
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

    nginx.virtualHosts.${config.services.mediawiki.nginx.hostName} = {
      listenAddresses = [ "unix:/run/nginx/nginx.sock" ];
      locations = {
        "~ ^/static/(.+)$" = {
          alias = "${./static}/$1";
        };
        "/".extraConfig = lib.mkForce ''
          rewrite ^/(?<pagename>.*)$ /w/index.php;
        '';
        "= /robots.txt" = {
          alias = ./robots.txt;
        };
        "= /favicon.ico" = {
          alias = ./static/logo-144x144.png;
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
      package = pkgs.mysql84;
      dataDir = "/mnt/mysql";
      settings = {
        mysqld = {
          bind-address = "127.0.0.1";
          log-error = "${config.services.mysql.dataDir}/mysql_err.log";
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
    };

    mysqlBackup = {
      enable = shouldBackup;
      databases = [
        "mediawiki"
      ];
      location = "/mnt/backup-mysql";
      calendar = "Mon";
    };

    cloudflared = {
      enable = true;
      certificateFile = pkgs.asOpnixPath "smo-wiki/cloudflared.pem";
      tunnels = {
        "9594cc82-a65e-427b-bc88-35c3985402b6" = {
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
      cloudflared-tunnel-9594cc82-a65e-427b-bc88-35c3985402b6 = {
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
          unzip -d /var/lib/mediawiki/ /tmp/listed_ip.zip
        '';
        serviceConfig = {
          Type = "oneshot";
        };
      };
    };
    timers.ip-list-refresh = {
      wantedBy = [ "timers.target" ];
      requires = [ "network-online.target" ];
      timerConfig = {
        OnCalendar = "00:00:00";
        Persistent = true;
        Unit = [ "ip-list-refresh.service" ];
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
