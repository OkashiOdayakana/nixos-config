{ config, pkgs, ... }:
{
  sops.secrets.unpoller_pass = {
    owner = "unifi-poller";
  };
  services.unifi = {
    enable = true;
    unifiPackage = pkgs.unifi8;
    mongodbPackage = pkgs.mongodb-ce;
  };
  services.unpoller = {
    enable = true;
    unifi = {
      defaults = {
        url = "https://localhost:8443";
        verify_ssl = false;
        user = "unpoller";
        pass = config.sops.secrets.unpoller_pass.path;
      };
    };
    loki = {
      url = "http://localhost:9428/insert";
    };
    influxdb.disable = true;
  };
  services.caddy.virtualHosts."unifi.okashi-lan.org" = {
    extraConfig = ''
      import https_header
      encode {
          zstd better
      }
      reverse_proxy [::1]:8443 {  # the unifi controller runs on the same machine as caddy
        transport http {
            tls_insecure_skip_verify  # we don't verify the controller https cert
        }
        header_up - Authorization  # sets header to be passed to the controller
      }
    '';
  };
}
