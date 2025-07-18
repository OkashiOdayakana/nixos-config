{ config, ... }:
{
  flake.modules.nixos.server.imports = with config.flake.modules.nixos; [
    caddy-reverse-proxies
    openssh
    fail2ban
  ];
}
