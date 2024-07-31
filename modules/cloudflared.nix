{
  config,
  pkgs,
  lib,
  ...
}:
{
  sops.secrets.tunnel_credentials = {
    owner = "cloudflared";
    group = "cloudflared";
    name = "tunnel_credentials.json";
  };

  services.cloudflared = {
    enable = true;
    user = "cloudflared";
    tunnels."5c1e01cc-2933-4724-b31a-a4d506ba461b" = {
      credentialsFile = config.sops.secrets.tunnel_credentials.path;
      default = "http_status:404";
    };
  };
}
