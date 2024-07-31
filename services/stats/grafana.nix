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

  services.caddy.virtualHosts."grafana.lan".extraConfig = ''
    tls internal
    @websockets {
        header Connection Upgrade
        header Upgrade websocket
    }
    reverse_proxy http://127.0.0.1:${toString config.services.grafana.port}
  '';
}
