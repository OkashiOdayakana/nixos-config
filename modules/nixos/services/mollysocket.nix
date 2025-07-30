{
  flake.modules.nixos.mollysocket =
    { config, ... }:
    {
      sops.secrets.mollysocket-key = {
      };
      services.mollysocket = {
        enable = true;
        environmentFile = config.sops.secrets.mollysocket-key.path;
      };
      services.caddy.reverseProxies."molly.t4tlabs.net".port = 8020;
    };
}
