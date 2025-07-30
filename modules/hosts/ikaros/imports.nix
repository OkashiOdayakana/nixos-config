{
  config,
  ...
}:
{
  nixosHosts.ikaros = {
    tailscale-ip6 = "fd7a:115c:a1e0::4201:7c39";
  };

  flake.modules.nixos.host_ikaros =
    { inputs, ... }:
    {
      system.stateVersion = "24.05";

      imports = with config.flake.modules.nixos; [
        inputs.lanzaboote.nixosModules.lanzaboote
        server
        mastodon
        attic
        miniflux
        ntp-client
        ntfy
        mollysocket
        ./_nixos
      ];
      services.tailscale = {
        openFirewall = true;
        useRoutingFeatures = "server";
      };

    };
}
