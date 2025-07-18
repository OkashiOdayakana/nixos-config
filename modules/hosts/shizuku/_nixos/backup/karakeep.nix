{ config, ... }:
{
  sops.secrets.karakeep_env = { };
  virtualisation.oci-containers = {
    backend = "podman";
    containers = {
      karakeep = {
        image = "ghcr.io/karakeep-app/karakeep:release";
        extraOptions = [
          "--device=/dev/dri/renderD128:/dev/dri/renderD128"
        ];
        volumes = [
          "data:/data"
        ];
        ports = [ "3069:3000" ];
        environmentFiles = [
          config.sops.secrets.karakeep_env.path
        ];
      };
      chrome = {
        image = "gcr.io/zenika-hub/alpine-chrome:latest";
        cmd = [
          "--no-sandbox"
          "--disable-gpu"
          "--disable-dev-shm-usage"
          "--remote-debugging-address=0.0.0.0"
          "--remote-debugging-port=9222"
          "--hide-scrollbars"
        ];
      };
      meilisearch = {
        image = "getmeili/meilisearch:v1.11.1";
        environmentFiles = [
          config.sops.secrets.karakeep_env.path
        ];
        volumes = [ "meilisearch:/meili_data" ];
      };
    };
  };

  services.caddy.reverseProxies."keep.okashi-lan.org".port = 3069;

}
