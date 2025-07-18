{
  config,
  pkgs,
  ...
}:

{

  sops.secrets.synapse-oidc = {
    sopsFile = ../../../../secrets/ikaros/synapse-oidc;
    owner = "matrix-synapse";
    format = "binary";
  };

  services.postgresql.enable = true;
  services.postgresql.initialScript = pkgs.writeText "synapse-init.sql" ''
    CREATE ROLE "matrix-synapse" WITH LOGIN PASSWORD 'synapse';
    CREATE DATABASE "matrix-synapse" WITH OWNER "matrix-synapse"
      TEMPLATE template0
      LC_COLLATE = "C"
      LC_CTYPE = "C";
  '';

  services.caddy.reverseProxies."matrix.t4tlabs.net".port = 8008;

  services.matrix-synapse = {
    enable = true;
    extraConfigFiles = [ config.sops.secrets.synapse-oidc.path ];
    settings = {
      server_name = "t4tlabs.net";
      public_baseurl = "https://matrix.t4tlabs.net";
      listeners = [
        {
          port = 8008;
          bind_addresses = [ "::1" ];
          type = "http";
          tls = false;
          x_forwarded = true;
          resources = [
            {
              names = [
                "client"
                "federation"
              ];
              compress = false;
            }
          ];
        }
      ];
      enable_registration = false;
      password_config.enabled = false;
    };
  };
}
