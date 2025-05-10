{ config, ... }:
{

  services.nix-serve = {
    enable = true;
    secretKeyFile = "/var/cache-priv-key.pem";
  };

  services.caddy.virtualHosts."http://binary.okashi-lan.org".extraConfig = ''
    reverse_proxy http://${config.services.nix-serve.bindAddress}:${toString config.services.nix-serve.port} 
  '';
}
