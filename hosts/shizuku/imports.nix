{
  config,
  inputs,
  ...
}:
{
  nixosHosts.shizuku = { };

  flake.modules.nixos.host_shizuku = {
    system.stateVersion = "24.05";

    imports = with config.flake.modules.nixos; [
      server
      inputs.lanzaboote.nixosModules.lanzaboote
      jellyfin
      postgresql
      ./_nixos
    ];

  };
}
