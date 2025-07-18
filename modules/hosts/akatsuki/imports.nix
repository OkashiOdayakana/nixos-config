{
  config,
  ...
}:
{
  nixosHosts.akatsuki = { };

  flake.modules.nixos.host_akatsuki = {
    system.stateVersion = "25.05";

    imports = with config.flake.modules.nixos; [
      server
      ./_nixos
    ];
  };
}
