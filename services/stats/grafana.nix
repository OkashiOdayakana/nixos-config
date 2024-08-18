{ config, ... }:
{
  services.grafana = {
    enable = true;
    settings = {
      panels = {
        disable_sanitize_html = true;
      };
      server = {
        http_domain = "grafana.lan";
        http_port = 2342;
        http_addr = "127.0.0.1";
      };
      analytics.reporting_enabled = false;
    };
  };

  services.caddy.virtualHosts."grafana.okash.it".extraConfig = ''
    encode {
        zstd better
    }
    reverse_proxy http://localhost:2342
  '';
}
