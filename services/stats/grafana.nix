{ config, pkgs, ... }:
{
  services.grafana = {
    enable = true;
    domain = "grafana.lan";
    port = 2342;
    addr = "127.0.0.1";
  };

  services.caddy.virtualHosts."grafana.lan".extraConfig = ''
    @websockets {
        header Connection Upgrade
        header Upgrade websocket
    }
    reverse_proxy @websockets http://127.0.0.1:${toString config.services.grafana.port}
  '';
}
