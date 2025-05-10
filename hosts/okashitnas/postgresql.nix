{ pkgs, config, ... }:
{
  sops.secrets = {
    "db/vaultwarden" = {
      owner = "postgres";
      group = "vaultwarden";
    };
    cf-acme = { };
  };

  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_16;

    ensureDatabases = [
      "vaultwarden"
    ];
    enableTCPIP = true;
    ensureUsers = [
      {
        name = "vaultwarden";
        ensureDBOwnership = true;
      }
    ];
    authentication = pkgs.lib.mkOverride 10 ''
      #type database  DBuser  auth-method
      local all all trust
    '';
  };
  systemd.services.postgresql = {
    postStart =
      let
        vaultwarden_password_file = config.sops.secrets."db/vaultwarden".path;
      in
      ''
        $PSQL -tA <<'EOF'
          DO $$
          DECLARE password TEXT;
          BEGIN
            password := trim(both from replace(pg_read_file('${vaultwarden_password_file}'), E'\n', '''));
            EXECUTE format('ALTER ROLE vaultwarden WITH PASSWORD '''%s''';', password);
          END $$;
        EOF
      '';
  };
}
