{ config, pkgs, ... }:
{
  sops.secrets."db/blocky" = { };
  services.resolved = {
    enable = false;
  };
  services.blocky = {
    enable = true;
    settings = {
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
        blackLists = {
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
            "malware"
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
          "grafana.lan" = "192.168.1.5";
        };
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
        http = 4000;
      };
      # Enable Prometheus exporting
      prometheus = {
        enable = true;
        path = "/metrics";
      };
      queryLog = {
        type = "postgresql";
        target = "postgresql://blocky?host=/var/run/postgresql";
        #:aapz9AVPPW7rJfAAogtiwraL@socket(/var/lib/postgresql)/blocky";
        logRetentionDays = 7;
      };
    };
  };
  services.postgresql = {
    enable = true;
    ensureDatabases = [ "blocky" ];
    enableTCPIP = true;
    ensureUsers = [
      {
        name = "blocky";
        ensureDBOwnership = true;
      }
    ];
    authentication = pkgs.lib.mkOverride 10 ''
      #type database  DBuser  auth-method
      local all       all     trust
      host  blocky    blocky  192.168.1.5/32 password
    '';
  };
  systemd.services.postgresql.postStart =
    let
      password_file_path = config.sops.secrets."db/blocky".path;
    in
    ''
      $PSQL -tA <<'EOF'
        DO $$
        DECLARE password TEXT;
        BEGIN
          password := trim(both from replace(pg_read_file('${password_file_path}'), E'\n', '''));
          EXECUTE format('ALTER ROLE blocky WITH PASSWORD '''%s''';', password);
        END $$;
      EOF
    '';
}
