{
  config,
  inputs,
  ...
}:
{
  nixosHosts.athena = { };

  flake.modules.nixos.host_athena = {
    system.stateVersion = "25.05";

    imports = with config.flake.modules.nixos; [
      desktop
      desktop_kde
      laptop
      graphics_intel
      ntp-client
      inputs.lanzaboote.nixosModules.lanzaboote
    ];

  };
}
