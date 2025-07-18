{
  flake.modules.nixos.server =
    { pkgs, ... }:
    {
      powerManagement.enable = true;
      powerManagement.cpuFreqGovernor = "performance";

      services.redis.package = pkgs.valkey;
    };
}
