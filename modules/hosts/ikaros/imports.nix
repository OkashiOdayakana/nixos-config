{
  config,
  ...
}:
{
  nixosHosts.ikaros = { };

  flake.modules.nixos.host_ikaros =
    { inputs, ... }:
    {
      system.stateVersion = "24.05";

      imports = with config.flake.modules.nixos; [
        inputs.lanzaboote.nixosModules.lanzaboote
        server
        mastodon
        attic
        ./_nixos
      ];
      services.tailscale = {
        openFirewall = true;
        useRoutingFeatures = "server";
      };

    };
}
