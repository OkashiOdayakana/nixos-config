{
  flake.modules.nixos.calibre =
    { ... }:
    {
      virtualisation.oci-containers = {
        backend = "podman";
        containers = {
          calibre-web-automated = {
            image = "crocodilestick/calibre-web-automated:latest";
            volumes = [
              "/Nas-main/calibre:/calibre-library"
            ];
            ports = [ "8083:8083" ];
            environment = {
              PUID = "1000";
              PGID = "1000";
              TZ = "America/New_York";
            };
          };
        };
      };
      services.caddy.reverseProxies."books.okashi-lan.org".port = 8083;
    };
}
