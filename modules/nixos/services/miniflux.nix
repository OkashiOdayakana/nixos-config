{
  flake.modules.nixos.miniflux =
    { config, ... }:
    {
      sops.secrets.miniflux-config = {
        sopsFile = ../../../secrets/ikaros/miniflux-config;
        format = "binary";
      };
      services.miniflux = {
        enable = true;
        config = {
          CLEANUP_FREQUENCY = 48;
          LISTEN_ADDR = "localhost:8078";
          BASE_URL = "https://miniflux.t4tlabs.net";
        };

        adminCredentialsFile = config.sops.secrets.miniflux-config.path;
      };
      services.caddy.reverseProxies."miniflux.t4tlabs.net".port = 8078;
    };
}
