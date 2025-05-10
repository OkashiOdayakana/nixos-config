{
  config,
  pkgs,
  lib,
  ...
}:
{
  sops.secrets.nextcloud-pass = {
    owner = "nextcloud";
    group = "nextcloud";
  };
  services.postgresql = {
    ensureDatabases = [ "nextcloud" ];
    ensureUsers = [
      {
        name = "nextcloud";
        ensureDBOwnership = true;
      }
    ];
  };
  #pkgs.redis = pkgs.valkey;
  services.redis.package = pkgs.valkey;
  services.nextcloud = {
    enable = true;
    hostName = "cloud.okashi-lan.org";
    package = pkgs.nextcloud31;
    home = "/Nas-main/nextcloud-new/files";

    # Let NixOS install and configure the database automatically.
    database.createLocally = true;

    # Let NixOS install and configure Redis caching automatically.
    configureRedis = true;

    # Increase the maximum file upload size to avoid problems uploading videos.
    maxUploadSize = "16G";
    https = true;
    autoUpdateApps.enable = true;

    config = {
      dbtype = "pgsql";
      adminuser = "admin";
      adminpassFile = config.sops.secrets.nextcloud-pass.path;

      #extraTrustedDomains = [ "nextcloud.okash.it" ];
    };
    settings = {
      maintenance_window_start = 5;
      trusted_proxies = [
        "127.0.0.1"
        "::1"
      ];
      overwriteprotocol = "https";
      default_phone_region = "US";
    };

    extraAppsEnable = false;
    extraApps = {
      inherit (config.services.nextcloud.package.packages.apps)
        contacts
        calendar
        tasks
        ;
    };
    #extraOptions.enabledPreviewProviders = [
    #  "OC\\Preview\\BMP"
    #  "OC\\Preview\\GIF"
    #  "OC\\Preview\\JPEG"
    #  "OC\\Preview\\Krita"
    #  "OC\\Preview\\MarkDown"
    #  "OC\\Preview\\MP3"
    #  "OC\\Preview\\OpenDocument"
    #  "OC\\Preview\\PNG"
    #  "OC\\Preview\\TXT"
    #  "OC\\Preview\\XBitmap"
    #  "OC\\Preview\\HEIC"
    #];

    phpOptions = {
      "opcache.interned_strings_buffer" = "16";
    };

  };

  services.phpfpm.pools.nextcloud.settings = {
    "listen.owner" = config.services.caddy.user;
    "listen.group" = config.services.caddy.group;
  };
  users.users.caddy.extraGroups = [ "nextcloud" ];

  services.nginx.enable = false;
  services.caddy.virtualHosts."cloud.okashi-lan.org" = {
    extraConfig = ''
      encode zstd gzip

          root * ${config.services.nginx.virtualHosts.${config.services.nextcloud.hostName}.root}

          redir /.well-known/carddav /remote.php/dav 301
          redir /.well-known/caldav /remote.php/dav 301
          redir /.well-known/* /index.php{uri} 301
          redir /remote/* /remote.php{uri} 301

          header {
            Strict-Transport-Security max-age=31536000
            Permissions-Policy interest-cohort=()
            X-Content-Type-Options nosniff
            X-Frame-Options SAMEORIGIN
            Referrer-Policy no-referrer
            X-XSS-Protection "1; mode=block"
            X-Permitted-Cross-Domain-Policies none
            X-Robots-Tag "noindex, nofollow"
            -X-Powered-By
          }

          php_fastcgi unix/${config.services.phpfpm.pools.nextcloud.socket} {
            root ${config.services.nginx.virtualHosts.${config.services.nextcloud.hostName}.root}
            env front_controller_active true
            env modHeadersAvailable true
          }

          @forbidden {
            path /build/* /tests/* /config/* /lib/* /3rdparty/* /templates/* /data/*
            path /.* /autotest* /occ* /issue* /indie* /db_* /console*
            not path /.well-known/*
          }
          error @forbidden 404

          @immutable {
            path *.css *.js *.mjs *.svg *.gif *.png *.jpg *.ico *.wasm *.tflite
            query v=*
          }
          header @immutable Cache-Control "max-age=15778463, immutable"

          @static {
            path *.css *.js *.mjs *.svg *.gif *.png *.jpg *.ico *.wasm *.tflite
            not query v=*
          }
          header @static Cache-Control "max-age=15778463"

          @woff2 path *.woff2
          header @woff2 Cache-Control "max-age=604800"

          file_server
    '';
  };
}
