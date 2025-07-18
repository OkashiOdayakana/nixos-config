{ config, pkgs, ... }:
{
  sops.secrets = {
    cf-acme = {
      owner = "stalwart-mail";
    };
    stalwart-adm-pw = {
      owner = "stalwart-mail";
    };
    mail-pw = {
      owner = "stalwart-mail";
    };
  };
  services.stalwart-mail = {
    enable = true;
    package = pkgs.stalwart-mail;
    openFirewall = true;
    settings = {
      server = {
        hostname = "mx1.okashi.me";
        tls = {
          enable = true;
          implicit = true;
        };
        listener = {
          smtp = {
            protocol = "smtp";
            bind = "[::]:25";
          };
          submissions = {
            bind = "[::]:465";
            protocol = "smtp";
          };
          imaps = {
            bind = "[::]:993";
            protocol = "imap";
            implicit = true;
          };
          management = {
            bind = [ "127.0.0.1:8080" ];
            protocol = "http";
          };
        };
      };
      lookup.default = {
        hostname = "mx1.okashi.me";
        domain = "okashi.me";
      };
      acme."letsencrypt" = {
        directory = "https://acme-v02.api.letsencrypt.org/directory";
        challenge = "dns-01";
        contact = "okashi@okash.it";
        domains = [
          "okashi.me"
          "mx1.okashi.me"
        ];
        provider = "cloudflare";
        secret = "%{file:${config.sops.secrets.cf-acme.path}}%";
      };
      session.auth = {
        mechanisms = "[plain]";
        directory = "'in-memory'";
      };
      storage.directory = "in-memory";
      session.rcpt.directory = "'in-memory'";
      queue.outbound.next-hop = "'local'";
      directory."imap".lookup.domains = [ "okashi.me" ];
      directory."in-memory" = {
        type = "memory";
        principals = [
          {
            class = "individual";
            name = "Okashi";
            secret = "%{file:${config.sops.secrets.mail-pw.path}}%";
            email = [ "okashi@okashi.me" ];
          }
        ];
      };
      authentication.fallback-admin = {
        user = "admin";
        secret = "%{file:${config.sops.secrets.stalwart-adm-pw.path}}%";
      };
    };
  };

  services.caddy.virtualHosts = {
    "webadmin.okashi.me" = {
      extraConfig = ''
        import tls_settings
        reverse_proxy http://127.0.0.1:8080
      '';
      serverAliases = [
        "mta-sts.okashi.me"
        "autoconfig.okashi.me"
        "autodiscover.okashi.me"
        "mail.okashi.me"
      ];
    };
  };
}
