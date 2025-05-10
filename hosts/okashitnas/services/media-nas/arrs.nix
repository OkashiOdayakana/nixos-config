{ ... }:
{
  services = {
    sonarr = {
      enable = true;
    };
    caddy.virtualHosts."sonarr.okashi-lan.org" = {
      extraConfig = ''
        import https_header
        reverse_proxy localhost:8989
      '';
    };

    radarr = {
      enable = true;
    };
    caddy.virtualHosts."radarr.okashi-lan.org" = {
      extraConfig = ''
        import https_header
        reverse_proxy localhost:7878
      '';
    };
    prowlarr = {
      enable = true;
    };
    caddy.virtualHosts."prowlarr.okashi-lan.org" = {
      extraConfig = ''
        import https_header
        reverse_proxy localhost:9696
      '';
    };
  };
}
