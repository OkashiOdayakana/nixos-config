{ config, ... }:
{
  sops.secrets = {
    lldap_key_seed = {
      owner = "lldap";
    };
    lldap_jwt_secret = {
      owner = "lldap";
    };
    lldap_user_pass = {
      owner = "lldap";
    };
  };
  users = {
    groups."lldap" = { };
    users."lldap" = {
      group = "lldap";
      isSystemUser = true;
    };
  };
  services.postgresql = {
    ensureDatabases = [ "lldap" ];
    ensureUsers = [
      {
        name = "lldap";
        ensureDBOwnership = true;
      }
    ];
  };
  services.lldap = {
    enable = true;
    settings = {
      http_url = "https://ldap.okashi-lan.org";
      ldap_base_dn = "dc=okashi,dc=cloud";
      database_url = "postgres://lldap:TEST@localhost:5432/lldap?host=/var/run/postgresql";
      key_seed = config.sops.secrets.lldap_key_seed.path;
      force_ldap_user_pass_reset = "always";
    };
    environment = {
      LLDAP_JWT_SECRET_FILE = config.sops.secrets.lldap_jwt_secret.path;
      LLDAP_LDAP_USER_PASS_FILE = config.sops.secrets.lldap_user_pass.path;
    };
  };

  services.caddy.reverseProxies."ldap.okashi-lan.org".port = 17170;
}
