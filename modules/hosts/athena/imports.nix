{
  config,
  inputs,
  ...
}:
{
  nixosHosts.athena = { };

  flake.modules.nixos.host_athena = {
    system.stateVersion = "25.11";

    imports = with config.flake.modules.nixos; [
      desktop
      desktop_kde
      laptop
      graphics_amd
      ntp-client
      inputs.lanzaboote.nixosModules.lanzaboote
      inputs.nix-mineral.nixosModules.nix-mineral
    ];

  };
}
