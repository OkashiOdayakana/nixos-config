{ pkgs, config, ... }:
{
  sops.secrets = {
    "db/vaultwarden" = {
      owner = "postgres";
      group = "vaultwarden";
    };
    "db/blocky" = {
      owner = "postgres";
    };
    cf-acme = { };
  };
  security.acme = {
    acceptTerms = true;
    defaults.email = "okashi@okash.it";
    useRoot = true;
    certs."BLS08807.okash.it" = {
      group = "postgres";

      dnsProvider = "cloudflare";
      credentialFiles = {
        "CF_DNS_API_TOKEN_FILE" = config.sops.secrets.cf-acme.path;
      };
      dnsPropagationCheck = true;
    };

  };
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_15;
    settings = {
      ssl = true;
      ssl_cert_file = "/var/lib/acme/BLS08807.okash.it/fullchain.pem";
      ssl_key_file = "/var/lib/acme/BLS08807.okash.it/key.pem";
    };
    ensureDatabases = [
      "vaultwarden"
      "blocky"
    ];
    enableTCPIP = true;
    ensureUsers = [
      {
        name = "vaultwarden";
        ensureDBOwnership = true;
      }
      {
        name = "blocky";
        ensureDBOwnership = true;
      }
    ];
    authentication = pkgs.lib.mkOverride 10 ''
      #type database  DBuser  auth-method
      local all all trust
      host  blocky    blocky  192.168.1.1/32 scram-sha-256
    '';
  };
  systemd.services.postgresql = {
    postStart =
      let
        vaultwarden_password_file = config.sops.secrets."db/vaultwarden".path;
        blocky_password_file = config.sops.secrets."db/blocky".path;
      in
      ''
        $PSQL -tA <<'EOF'
          DO $$
          DECLARE password TEXT;
          BEGIN
            password := trim(both from replace(pg_read_file('${vaultwarden_password_file}'), E'\n', '''));
            EXECUTE format('ALTER ROLE vaultwarden WITH PASSWORD '''%s''';', password);
          END $$;
          DO $$
          DECLARE password TEXT;
          BEGIN
            password := trim(both from replace(pg_read_file('${blocky_password_file}'), E'\n', '''));
            EXECUTE format('ALTER ROLE blocky WITH PASSWORD '''%s''';', password);
          END $$;
        EOF
      '';
  };
}
