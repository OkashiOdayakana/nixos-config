{ config, ... }:
{
  sops.secrets.lldap_user_pass = {
    mode = "0440";
    group = "radicale";
  };
  services.radicale = {
    enable = true;
    settings = {
      server.hosts = [ "localhost:5232" ];
      auth = {
        type = "ldap";
        ldap_uri = "ldap://localhost:3890";
        ldap_base = "dc=okashi,dc=cloud";
        ldap_reader_dn = "uid=admin,ou=people,dc=okashi,dc=cloud";
        ldap_secret_file = "${config.sops.secrets.lldap_user_pass.path}";
        ldap_filter = "(&(objectClass=person)(uid={0}))";
        lc_username = true;
      };
    };
  };

  services.caddy.reverseProxies."cal.okashi-lan.org".port = 5232;

}
