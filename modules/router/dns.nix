{
  config,
  pkgs,
  lib,
  ...
}:
{
  sops.secrets."db/blocky" = { };
  sops.secrets.cf-acme = { };
  services.resolved = {
    enable = false;
  };
  security.acme = {
    acceptTerms = true;
    defaults.email = "okashi@okashi.me";
    useRoot = true;
    certs."doh.okash.it" = {
      dnsProvider = "cloudflare";
      credentialFiles = {
        "CF_DNS_API_TOKEN_FILE" = config.sops.secrets.cf-acme.path;
      };
      dnsPropagationCheck = true;
    };

  };
  services.blocky = {
    enable = true;
  };
  sops.templates.blocky.content = lib.generators.toYAML { } {
    upstreams.groups.default = [
      "https://one.one.one.one/dns-query" # Using Cloudflare's DNS over HTTPS server for resolving queries.
      "https://dns.quad9.net/dns-query"
      "https://freedns.controld.com/p0"
      "https://unfiltered.adguard-dns.com/dns-query"
    ];
    # For initially solving DoH/DoT Requests when no system Resolver is available.
    bootstrapDns = {
      upstream = "https://one.one.one.one/dns-query";
      ips = [
        "1.1.1.1"
        "1.0.0.1"
      ];
    };
    #Enable Blocking of certian domains.
    blocking = {
      denylists = {
        malware = [ "https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/wildcard/tif.txt" ];
        #Adblocking
        ads = [ "https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/wildcard/pro.plus.txt" ];
        # Prevent bypass via DoH/whatever
        bypass = [ "https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/wildcard/doh.txt" ];
      };
      #Configure what block categories are used
      clientGroupsBlock = {
        default = [
          "ads"
          "bypass"
        ];
      };
    };
    caching = {
      minTime = "12h";
      maxTime = "72h";
      prefetching = true;
    };
    customDNS = {
      mapping = {
        "ha.okash.it" = "192.168.1.5";
        "vw.okash.it" = "192.168.1.5";
        "grafana.okash.it" = "192.168.1.5";
        "nextcloud.okash.it" = "192.168.1.5";
        "doh.okash.it" = "192.168.1.1";
      };
      #zone = ''
      #  $ORIGIN vw.okash.it.         432000   IN      HTTPS   1 . alpn="h3,h2" ipv4hint=192.168.1.5
      #'';
      #zone = ''
      #    $ORIGIN example.com.
      #  www 3600 A 1.2.3.4
      #  @ 3600 CNAME www
      #'';
    };
    ede = {
      enable = false;
    };
    clientLookup = {
      upstream = "192.168.1.1:5353";
    };
    conditional = {
      mapping = {
        "lan" = "192.168.1.1:5353";
        "." = "192.168.1.1:5353";
      };
    };
    # I want to use .lan, so this must be disabled:
    specialUseDomains.rfc6762-appendixG = false;
    # Enable http listener
    ports = {
      dns = 53;
      tls = 853;
      http = 4000;
      https = 443;
    };
    certFile = "/run/credentials/blocky.service/cert";
    keyFile = "/run/credentials/blocky.service/key";
    # Enable Prometheus exporting
    prometheus = {
      enable = true;
      path = "/metrics";
    };
    queryLog = {
      type = "postgresql";
      target = "postgresql://blocky:${
        config.sops.placeholder."db/blocky"
      }@192.168.1.5/blocky?sslmode=verify-ca";
      logRetentionDays = 7;
    };
  };

  systemd.services.blocky = {
    description = "A DNS proxy and ad-blocker for the local network";
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      DynamicUser = true;
      LoadCredential = [
        "config-yml:${config.sops.templates.blocky.path}"
        "cert:/var/lib/acme/doh.okash.it/fullchain.pem"
        "key:/var/lib/acme/doh.okash.it/key.pem"
      ];
      ExecStart = lib.mkForce "${lib.getExe config.services.blocky.package} --config %d/config-yml";
      Restart = "on-failure";

      AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];
      CapabilityBoundingSet = [ "CAP_NET_BIND_SERVICE" ];
    };
  };

}
