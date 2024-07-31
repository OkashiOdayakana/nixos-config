# sovserv/caddy.nix
{
  pkgs,

  ...
}:

{
  services.caddy = {
    enable = true;
    # logFormat = ''
    #   level DEBUG
    # '';
    package = pkgs.caddy-cloudflare;
  };
}
