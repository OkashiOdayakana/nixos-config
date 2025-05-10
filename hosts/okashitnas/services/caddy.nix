{ config, pkgs, ... }:
{
  sops.secrets.cf-api-lan = { };
  sops.secrets.cf-acme = { };
  security.acme = {
    acceptTerms = true;
    defaults = {
      email = "okashi@okash.it";
      dnsResolver = "1.1.1.1:53";
      dnsPropagationCheck = true;
      dnsProvider = "cloudflare";
      keyType = "ec384";
      credentialFiles = {
        "CF_DNS_API_TOKEN_FILE" = config.sops.secrets.cf-acme.path;
        "CF_ZONE_API_TOKEN_FILE" = config.sops.secrets.cf-acme.path;
      };
    };

    certs = {
      "auth.okashi-lan.org" = {
        group = "idm-cert";
      };
    };
  };
  users.groups.idm-cert.members = [
    "kanidm"
    "caddy"
  ];
  services.caddy = {
    enable = true;
    email = "okashi@okash.it";
    package = pkgs.caddy.withPlugins {
      plugins = [ "github.com/caddy-dns/cloudflare@v0.2.1" ];
      hash = "sha256-saKJatiBZ4775IV2C5JLOmZ4BwHKFtRZan94aS5pO90=";
    };
    environmentFile = config.sops.secrets.cf-api-lan.path;
    extraConfig = ''
               (acme_mtls) {
          tls okashi@okash.it {
              ca https://ca.okashi-lan.org:9443/acme/acme/directory
              ca_root /etc/certs/root_ca.crt
              client_auth {
                  mode require_and_verify
                  trust_pool file {
                      pem_file /etc/certs/root_ca.crt
                  }
              }
          }
      }

                  (https_header) {
                  tls {
            	    dns cloudflare {env.CF_API_TOKEN}
                    resolvers 1.1.1.1
                  }

                       header {
                        Strict-Transport-Security "max-age=31536000; includeSubdomains; preload"
                        X-XSS-Protection "1; mode=block"
                        X-Content-Type-Options "nosniff"
                        Referrer-Policy "same-origin"
                       -Server
                        Permissions-Policy "geolocation=(self) , microphone=()"
                      }
                  }
    '';
  };
}
