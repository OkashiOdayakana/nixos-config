{ ... }:

{
  services.immich = {
    enable = true;
    mediaLocation = "/Nas-main/immich";
    accelerationDevices = [ "/dev/dri/renderD128" ];
    machine-learning.environment = {
      MPLCONFIGDIR = "/var/lib/immich/mpllib";
    };
  };
  users.users.immich.extraGroups = [
    "video"
    "render"
  ];

  services.immich-public-proxy = {
    enable = true;
    immichUrl = "http://localhost:2283";
  };

  services.caddy.reverseProxies = {
    "immich.okashi-lan.org".port = 2283;
    "imgs.okash.it".port = 3000;
  };

}
