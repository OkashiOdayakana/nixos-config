{
  config,
  pkgs,
  lib,
  ...
}:
{
  sops.secrets.nextcloud-pass = {
    owner = "nextcloud";
  };
  services.nextcloud = {
    enable = true;
    hostName = "nextcloud.okash.it";
    package = pkgs.nextcloud29;

    # Let NixOS install and configure the database automatically.
    database.createLocally = true;

    # Let NixOS install and configure Redis caching automatically.
    configureRedis = true;

    # Increase the maximum file upload size to avoid problems uploading videos.
    maxUploadSize = "16G";
    https = true;

    autoUpdateApps.enable = true;
    extraAppsEnable = true;

    config = {
      overwriteProtocol = "https";
      defaultPhoneRegion = "US";
      dbtype = "pgsql";
      adminuser = "admin";
      adminpassFile = config.sops.secrets.nextcloud-pass.path;
    };

  };
}
