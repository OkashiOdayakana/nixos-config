{
  config,
  ...
}:
{
  sops.secrets = {
    "authelia/jwt-secret".owner = "authelia-main";
    "authelia/storage-encryption".owner = "authelia-main";
    "authelia/session-secret".owner = "authelia-main";
    "authelia/ldap-pwd".owner = "authelia-main";
    authelia-jwks = {
      owner = "authelia-main";
      sopsFile = ../../../../../secrets/shizuku/jwks.pem;
      format = "binary";
    };
    "authelia/hmac_secret".owner = "authelia-main";
    noreply-smtp-pwd.owner = "authelia-main";
  };
  services.postgresql = {
    ensureDatabases = [ "authelia-main" ];
    ensureUsers = [
      {
        name = "authelia-main";
        ensureDBOwnership = true;
      }
    ];
  };
  services.authelia.instances.main = {
    enable = true;
    secrets = with config.sops; {
      jwtSecretFile = secrets."authelia/jwt-secret".path;
      storageEncryptionKeyFile = secrets."authelia/storage-encryption".path;
      sessionSecretFile = secrets."authelia/session-secret".path;
      oidcIssuerPrivateKeyFile = secrets.authelia-jwks.path;
      oidcHmacSecretFile = secrets."authelia/hmac_secret".path;
    };
    environmentVariables = {
      "AUTHELIA_AUTHENTICATION_BACKEND_LDAP_PASSWORD_FILE" = config.sops.secrets."authelia/ldap-pwd".path;
      "AUTHELIA_NOTIFIER_SMTP_PASSWORD_FILE" = config.sops.secrets.noreply-smtp-pwd.path;
    };

    settings = {
      theme = "dark";
      default_2fa_method = "totp";
      totp.issuer = "auth.okashi-lan.org";
      default_redirection_url = "https://auth.okashi-lan.org";

      storage.postgres = {
        address = "unix:///var/run/postgresql";
        username = "authelia-main";
        password = "TEST";
        database = "authelia-main";
      };

      notifier = {
        disable_startup_check = true;
        smtp = {
          address = "submissions://smtp.migadu.com:465";
          username = "noreply@okash.it";
          sender = "Authelia <noreply@okash.it>";
          startup_check_address = "okashi@okashi.me";
          identifier = "shizuku";
        };
      };

      authentication_backend = {
        password_reset.disable = false;
        refresh_interval = "1m";

        ldap = {
          implementation = "lldap";
          address = "ldap://localhost:3890";
          base_dn = "dc=okashi,dc=cloud";
          user = "uid=bind_user,ou=people,dc=okashi,dc=cloud";
        };
      };
      session = {
        name = "authelia_session";
        expiration = "12h";
        inactivity = "45m";
        remember_me_duration = "1M";
        domain = "auth.okashi-lan.org";
        redis.host = "/run/redis-authelia-main/redis.sock";
        cookies = [
          {
            domain = "calibre.okashi-lan.org";
            authelia_url = "https://auth.okashi-lan.org";
            default_redirection_url = "https://calibre.okashi-lan.org";
          }
        ];
      };
      access_control = {
        default_policy = "one_factor";
      };

      identity_providers = {
        oidc = {
          claims_policies.karakeep.id_token = [ "email" ];
          clients = [
            {
              client_id = "jellyfin";
              client_name = "Jellyfin";
              client_secret = "$pbkdf2-sha512$310000$0arD/cTZL4Np0laRBRH.bA$fy.DsrR0Ab6abLJtTMS79bhC8Oc6AdLa0mEdxK1k7qmGN6RjYZb9ICb3KfBnrx9IJmeIhawR/Se1B.2WcbroNQ";
              public = false;
              authorization_policy = "two_factor";
              require_pkce = true;
              pkce_challenge_method = "S256";

              redirect_uris = [
                "https://jf.okashi-lan.org/sso/OID/redirect/authelia"
              ];

              scopes = [
                "openid"
                "profile"
                "groups"
              ];

              userinfo_signed_response_alg = "none";
              token_endpoint_auth_method = "client_secret_post";

            }
            {
              client_id = "immich";
              client_name = "Immich";
              client_secret = "$pbkdf2-sha512$310000$1uP5hvRVGWaKdo.JpQijlg$0NdauhXBH825wr9eWKO1nYuSw2Gz26HSJvMlikD8hgh5gTfvLbkrTc9r3oMnssdrg7bPU2HFj2JUTp2INWxXzQ";
              public = false;
              #authorization_policy = "two_factor";
              redirect_uris = [
                "https://immich.okashi-lan.org/auth/login"
                "https://immich.okashi-lan.org/user-settings"
                "app.immich:///oauth-callback"
              ];

              scopes = [
                "openid"
                "profile"
                "email"
              ];
              userinfo_signed_response_alg = "none";
              token_endpoint_auth_method = "client_secret_post";
            }
            {
              client_id = "grafana";
              client_name = "Grafana";
              client_secret = "$pbkdf2-sha512$310000$shQbVly.lOAFtcuAL/4EvQ$BaKJI59v9trrA2gPbF/Py4w4ThCkQElkJgIEhbWwHpyr9ikEb64RONVTaM4gnDKlSV8AS2yllQT2BpA/G1xCIg";
              public = false;
              authorization_policy = "two_factor";
              require_pkce = true;
              pkce_challenge_method = "S256";
              redirect_uris = [
                "https://grafana.okashi-lan.org/login/generic_oauth"
              ];
              scopes = [
                "openid"
                "profile"
                "groups"
                "email"
              ];
              userinfo_signed_response_alg = "none";
              token_endpoint_auth_method = "client_secret_basic";
            }

            {
              client_id = "cloudflare";
              client_name = "Cloudflare Zero Trust";
              client_secret = "$pbkdf2-sha512$310000$iBc2zjS7OQ4zg4KAi1vzvw$Q39pMH3EhDfTuLLTyoGNgyyju52jlAOozVDKmJ2frDYyzaUYFp8YxiXkA8oYCQRSS0WzaSpnJ9cGldKQGBez7A";
              public = false;
              authorization_policy = "two_factor";
              redirect_uris = [ "https://okashi.cloudflareaccess.com/cdn-cgi/access/callback" ];
              scopes = [
                "openid"
                "email"
                "profile"
              ];
              userinfo_signed_response_alg = "none";
            }
            {
              client_id = "karakeep";
              client_name = "Karakeep";
              claims_policy = "karakeep";
              client_secret = "$pbkdf2-sha512$310000$Mmeem3VAs61jVuElWbzBTA$RlWIlMzHZGXA7sWeqa9JayRbXrxOls9905fYBNaxyLXPjzSsI7acxaB6nu.Yyp3fzlmy/5XBPS675NVSsfXcRQ";
              public = false;
              authorization_policy = "two_factor";
              redirect_uris = [
                "https://keep.okashi-lan.org/api/auth/callback/custom"
              ];
              scopes = [
                "openid"
                "profile"
                "email"
              ];
              userinfo_signed_response_alg = "none";
            }
          ];
        };
      };

      server.endpoints.authz.forward-auth.implementation = "ForwardAuth";

    };
  };
  services.redis.servers.authelia-main = {
    enable = true;
    user = "authelia-main";
    port = 0;
    unixSocket = "/run/redis-authelia-main/redis.sock";
    unixSocketPerm = 600;
  };

  services.caddy.reverseProxies."auth.okashi-lan.org".port = 9091;
}
