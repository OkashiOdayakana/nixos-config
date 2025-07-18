{
  flake.modules.nixos.host_athena =
    { lib, ... }:
    {
      powerManagement.enable = true;
    };
}
