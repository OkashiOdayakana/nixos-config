{
  config,
  pkgs,
  inputs,
  ...
}:

let
  domain = "matrix.t4tlabs.net";
  pkgsMaster = import inputs.nixpkgs-master {
    inherit (pkgs.stdenv.hostPlatform) system;
    inherit (config.nixpkgs) config;
  };
in
{
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
      oidc_providers = [
        {
          idp_id = "keycloak";
          idp_name = "keycloak";
          issuer = "https://auth.t4tlabs.net/realms/t4tlabs";
          client_id = "matrix";
          client_secret = "nrlOvnQkh2Hi2XeM1tdEZsvztv2yP0ug";
          pkce_method = "always";
          scopes = [
            "openid"
            "profile"
          ];
          user_mapping_provider = {
            config = {
              localpart_template = "{{ user.preferred_username }}";
              display_name_template = "{{ user.name }}";
            };
          };
          backchannel_logout_enabled = true;
        }
      ];
    };
  };
}
