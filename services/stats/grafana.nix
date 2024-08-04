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

  services.nginx.virtualHosts."grafana.okash.it" = {
    addSSL = true;
    enableACME = true;
    locations."/grafana/" = {
      proxyPass = "http://${toString config.services.grafana.settings.server.http_addr}:${toString config.services.grafana.settings.server.http_port}";
      proxyWebsockets = true;
      recommendedProxySettings = true;
    };
    http3 = true;
  };
}
