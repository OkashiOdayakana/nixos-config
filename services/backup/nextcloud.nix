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
  services.nginx.virtualHosts."nextcloud.okash.it" = {
    forceSSL = true;
    enableACME = true;
    #http3 = true;
    #quic = true;
  };
  services.nextcloud = {
    enable = true;
    hostName = "nextcloud.okash.it";
    package = pkgs.nextcloud29;
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
      overwriteProtocol = "https";
      defaultPhoneRegion = "US";
      dbtype = "pgsql";
      adminuser = "admin";
      adminpassFile = config.sops.secrets.nextcloud-pass.path;
    };

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
}
