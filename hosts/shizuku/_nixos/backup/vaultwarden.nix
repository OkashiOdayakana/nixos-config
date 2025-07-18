{ config, ... }:
{
  sops.secrets.cloudflare-token = { };
  sops.secrets.vaultwarden_config = { };
  sops.secrets."db/vaultwarden" = {
    owner = "postgres";
    group = "vaultwarden";
  };
  services.vaultwarden = {
    enable = true;
    dbBackend = "postgresql";
    config = {
      DOMAIN = "https://vw.okashi-lan.org";
      SIGNUPS_ALLOWED = false;

      ROCKET_ADDRESS = "::1";
      ROCKET_PORT = 8222;

      DATABASE_URL = "postgresql://vaultwarden?host=/var/run/postgresql";

      PUSH_ENABLED = true;
    };
    environmentFile = config.sops.secrets.vaultwarden_config.path;
  };

  services.postgresql = {
    ensureDatabases = [
      "vaultwarden"
    ];
    ensureUsers = [
      {
        name = "vaultwarden";
        ensureDBOwnership = true;
      }
    ];
  };

  services.caddy.virtualHosts."vw.okashi-lan.org" = {
    extraConfig = ''
      encode {
          zstd better
      }
      tls {
        dns cloudflare {env.CF_API_TOKEN}
        resolvers 1.1.1.1
      }

       # Uncomment to improve security (WARNING: only use if you understand the implications!)
       # If you want to use FIDO2 WebAuthn, set X-Frame-Options to "SAMEORIGIN" or the Browser will block those requests
         header / {
       #	# Enable HTTP Strict Transport Security (HSTS)
       	St  Strict-Transport-Security "max-age=31536000;"
       #	# Disable cross-site filter (XSS)
        	X-XSS-Protection "0"
       #	# Disallow the site to be rendered within a frame (clickjacking protection)
        	X-Frame-Options "SAMEORIGIN"
       #	# Prevent search engines from indexing (optional)
        	X-Robots-Tag "noindex, nofollow"
       #	# Disallow sniffing of X-Content-Type-Options
        	X-Content-Type-Options "nosniff"
       #	# Server name removing
        	-Server
       #	# Remove X-Powered-By though this shouldn't be an issue, better opsec to remove
        	-X-Powered-By
       #	# Remove Last-Modified because etag is the same and is as effective
        	-Last-Modified
        }

       # Uncomment to allow access to the admin interface only from local networks
       # import admin_redir

       # Proxy everything to Rocket
       # if located at a sub-path the reverse_proxy line will look like:
       #   reverse_proxy /subpath/* <SERVER>:80
       reverse_proxy http://[::1]:8222 {
            # Send the true remote IP to Rocket, so that Vaultwarden can put this in the
            # log, so that fail2ban can ban the correct IP.
            header_up X-Real-IP {remote_host}
            # If you use Cloudflare proxying, replace remote_host with http.request.header.Cf-Connecting-Ip
            # See https://developers.cloudflare.com/support/troubleshooting/restoring-visitor-ips/restoring-original-visitor-ips/
            # and https://caddy.community/t/forward-auth-copy-headers-value-not-replaced/16998/4
       }
    '';
  };
  services.restic.backups.shizuku.paths = [ "/var/lib/bitwarden_rs" ];
}
