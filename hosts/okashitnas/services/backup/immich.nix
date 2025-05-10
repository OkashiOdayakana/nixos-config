{ config, ... }:

{
    services.immich = {
        enable = true;
        mediaLocation = "/Nas-main/immich";
        accelerationDevices = [ "/dev/dri/renderD128" ];
        machine-learning.environment = {
            MPLCONFIGDIR = "/var/lib/immich/mpllib";
        };
    };
    users.users.immich.extraGroups = [ "video" "render" ];

    services.immich-public-proxy = {
        enable = true;
        immichUrl = "http://localhost:2283";
    };

    services.caddy.virtualHosts = {
        "immich.okashi-lan.org" = {
            extraConfig = ''
                import acme_mtls
                import https_header
                encode {
                    zstd better
                }
            reverse_proxy http://localhost:2283
                '';
        };
        "imgs.okash.it" = {
            extraConfig = ''
                import https_header
                encode {
                    zstd better
                }
                reverse_proxy http://localhost:3000
            '';
        };
    };

}
