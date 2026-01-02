{
  flake.modules.nixos.caddy-reverse-proxies =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    {
      options = {
        services.caddy = {
          reverseProxies = lib.mkOption {
            type = lib.types.attrsOf (
              lib.types.submodule {
                options = {
                  port = lib.mkOption {
                    type = with lib.types; nullOr port;
                    default = null;
                  };

                  localIp = lib.mkOption {
                    type = lib.types.str;
                    default = "localhost";
                  };
                };
              }
            );
          };
        };
      };

      config =
        let
          cfg = config.services.caddy;
        in
        {
          sops.secrets.cf-api-key = {
            sopsFile = ./_secrets/cf-api-key;
            format = "binary";
          };
          services.caddy = {
            enable = true;

            email = "okashi@okash.it";
            package = pkgs.caddy.withPlugins {
              plugins = [ "github.com/caddy-dns/cloudflare@v0.2.1" ];
              hash = "sha256-Dvifm7rRwFfgXfcYvXcPDNlMaoxKd5h4mHEK6kJ+T4A=";
            };
            environmentFile = config.sops.secrets.cf-api-key.path;
            extraConfig = ''
              (tls_settings) {
                tls {
                      dns cloudflare {env.CF_API_TOKEN}
                  resolvers 1.1.1.1
                }
              }
            '';
            virtualHosts = lib.mapAttrs (domain: opts: {
              extraConfig =
                let
                  proxyStr = opts.localIp + lib.optionalString (opts.port != null) ":${toString opts.port}";
                in
                ''
                  import tls_settings
                  reverse_proxy ${proxyStr}
                '';
            }) cfg.reverseProxies;
          };
        };
    };
}
