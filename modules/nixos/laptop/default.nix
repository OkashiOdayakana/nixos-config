{
  flake.modules.nixos.laptop =
    { ... }:
    {
      services.thermald.enable = true;
      hardware.intel-gpu-tools.enable = true;
      services.power-profiles-daemon.enable = true;
    };
}
