{ config, rootPath, ... }:
{
  imports = [ ./ldap.nix ];
  sops.secrets = {
    keycloak-db-pwd = { };
  };

  services.keycloak = {
    enable = true;
    settings = {
      hostname = "https://auth.t4tlabs.net";
      http-enabled = true;
      hostname-strict-https = true;
      http-port = 8042;
      https-port = 8443;
      proxy-headers = "forwarded";
      proxy-trusted-addresses = "127.0.0.1/32,::1/128";
    };
    database.passwordFile = config.sops.secrets.keycloak-db-pwd.path;
  };

  services.caddy.reverseProxies."auth.t4tlabs.net".port = 8042;
}
