{ config, rootPath, ... }:

{
  sops.secrets.cf-tun-hl = {
    format = "binary";
    sopsFile = rootPath + /secrets/cf-tun-hl.json;
  };
  services.cloudflared = {
    enable = true;
    tunnels = {
      "338e6f29-a4ff-4bb9-aa81-081a6c3c4c06" = {
        credentialsFile = "${config.sops.secrets.cf-tun-hl.path}";
        default = "http_status:404";
      };
    };
  };
}
