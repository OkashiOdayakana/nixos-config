{
  flake.modules.nixos.ntfy =
    { ... }:
    {
      services.ntfy-sh = {
        enable = true;
        settings = {
          base-url = "https://ntfy.t4tlabs.net";
          behind-proxy = true;
          auth-default-access = "deny-all";
        };
      };

      services.caddy.virtualHosts."ntfy.t4tlabs.net".extraConfig = ''
        reverse_proxy 127.0.0.1:2586

        # Redirect HTTP to HTTPS, but only for GET topic addresses, since we want
        # it to work with curl without the annoying https:// prefix
        @httpget {
            protocol http
            method GET
            path_regexp ^/([-_a-z0-9]{0,64}$|docs/|static/)
        }
        redir @httpget https://{host}{uri}
      '';

    };
}
