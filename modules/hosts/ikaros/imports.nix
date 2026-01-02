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
      system.stateVersion = "25.11";

      imports = with config.flake.modules.nixos; [
        #inputs.lanzaboote.nixosModules.lanzaboote
        server
        #mastodon
        meilisearch
        sharkey
        attic
        miniflux
        ntp-client
        ntfy
        mollysocket
        vector
        podman
        cocoon
        ./_nixos
      ];
      services.tailscale = {
        openFirewall = true;
        useRoutingFeatures = "server";
      };

    };
}
