{ config, ... }:
{
  sops.secrets.grafana-authelia = {
    owner = "grafana";
  };
  services.grafana = {
    enable = true;
    settings = {
      panels = {
        disable_sanitize_html = true;
      };
      server = {
        root_url = "https://grafana.okashi-lan.org";
        http_domain = "grafana.okashi-lan.org";
        http_port = 2342;
        http_addr = "127.0.0.1";
      };
      analytics.reporting_enabled = false;
      "auth.generic_oauth" = {
        enabled = true;
        name = "Authelia";
        icon = "signin";
        client_id = "grafana";
        client_secret = "\$__file{${config.sops.secrets.grafana-authelia.path}}";
        scopes = "openid profile email groups";
        empty_scopes = false;
        auth_url = "https://auth.okashi-lan.org/api/oidc/authorization";
        token_url = "https://auth.okashi-lan.org/api/oidc/token";
        api_url = "https://auth.okashi-lan.org/api/oidc/userinfo";
        login_attribute_path = "preferred_username";
        groups_attribute_path = "groups";
        name_attribute_path = "name";
        role_attribute_path = "contains(groups, 'grafana_admin') && 'Admin' || contains(groups, 'grafana_editor') && 'Editor' || 'Viewer'";
        allow_assign_grafana_admin = true;
        skip_org_role_sync = true;
        use_pkce = true;
      };
    };
  };

  services.caddy.reverseProxies."grafana.okashi-lan.org".port = 2342;

}
