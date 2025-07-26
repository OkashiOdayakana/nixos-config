{
  flake.modules.nixos.calibre =
    { ... }:
    {
      services = {
        calibre-server = {
          enable = true;
          port = 8012;
          libraries = [
            "/Nas-main/calibre"
          ];
        };
        calibre-web = {
          enable = true;
          options = {
            reverseProxyAuth = {
              enable = true;
              header = "Remote-User";
            };
            calibreLibrary = "/Nas-main/calibre";
            enableBookConversion = true;
            enableBookUploading = true;
            enableKepubify = true;
          };
        };

        caddy.virtualHosts."calibre.okashi-lan.org".extraConfig = ''
          import tls_settings
          forward_auth localhost:9091 {
                  uri /api/authz/forward-auth
                  copy_headers Remote-User Remote-Groups Remote-Email Remote-Name
          }

          reverse_proxy localhost:8012
        '';
      };
    };
}
