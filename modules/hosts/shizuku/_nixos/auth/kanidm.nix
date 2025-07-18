{ config, ... }:

{

  services.kanidm = {
    enableServer = true;
    enableClient = true;
    clientSettings = {
      uri = "https://auth.okashi-lan.org";
    };
    serverSettings = {
      origin = "https://auth.okashi-lan.org";
      domain = "auth.okashi-lan.org";
      bindaddress = "[::1]:8300";
      ldapbindaddress = "[::1]:636";
      tls_chain = "${config.security.acme.certs."auth.okashi-lan.org".directory}/cert.pem";
      tls_key = "${config.security.acme.certs."auth.okashi-lan.org".directory}/key.pem";
    };
  };
  virtualisation.oci-containers = {
    backend = "podman";
    containers.radiusd = {
      image = "kanidm/radius:latest";
      volumes = [
        "/etc/kanidm/radius.toml:/data/radius.toml"
        "/etc/raddb/certs:/data/certs"
      ];
      extraOptions = [
        "--privileged"
        "--network=host"
      ];
    };
  };
  services.caddy.virtualHosts."auth.okashi-lan.org" = {
    extraConfig = ''
      encode {
        zstd better                                                                                               
      }
      reverse_proxy https://[::1]:8300 {
        transport http {
          tls_server_name "auth.okashi-lan.org"
        }
      }
    '';
  };
}
