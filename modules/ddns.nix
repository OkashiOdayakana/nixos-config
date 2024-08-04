{ config, ... }:
{
  sops.secrets.inadyn = {
    owner = "inadyn";
  };
  services.inadyn = {
    enable = true;
    settings = {
      allow-ipv6 = false;
      provider."cloudflare.com:1" = {
        username = "okash.it";
        hostname = "nextcloud.okash.it";
        include = config.sops.secrets.inadyn.path;
      };
      provider."cloudflare.com:2" = {
        username = "okash.it";
        hostname = "vw.okash.it";
        include = config.sops.secrets.inadyn.path;
      };
      provider."cloudflare.com:3" = {
        username = "okash.it";
        hostname = "ha.okash.it";
        include = config.sops.secrets.inadyn.path;
      };
      provider."cloudflare.com:4" = {
        username = "okash.it";
        hostname = "grafana.okash.it";
        include = config.sops.secrets.inadyn.path;
      };
    };
  };
}
