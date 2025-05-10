{ lib, config, pkgs, ... }:
with lib;
let
cfg = config.modules.caddySrv;
in
{
options = 
config = mkIf cfg.enable = {
  sops.secrets.cf-api-lan = {};
  sops.secrets.cf-acme = {};
  security.acme = {
    acceptTerms = true;
    defaults = {
      email = "okashi@okash.it";
      dnsResolver = "1.1.1.1:53";
      dnsPropagationCheck = true;
      dnsProvider = "cloudflare";
      keyType = "ec384";
      credentialFiles =
       { 
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
  #users.groups.idm-cert.members = [ "kanidm" "caddy" ];
  services.caddy = {
    enable = true;
    email = "okashi@okash.it";
    package = pkgs.caddy.withPlugins {
    plugins = [ "github.com/caddy-dns/cloudflare@v0.0.0-20250228175314-1fb64108d4de" ];
    hash = "sha256-3nvVGW+ZHLxQxc1VCc/oTzCLZPBKgw4mhn+O3IoyiSs=";
    };
    environmentFile = config.sops.secrets.cf-api-lan.path;
    extraConfig = ''

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
};
}
