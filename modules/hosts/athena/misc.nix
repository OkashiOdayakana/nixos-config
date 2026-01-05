{
  flake.modules.nixos.host_athena =
    { lib, ... }:
    {

      hardware = {
        enableRedistributableFirmware = true;
        wirelessRegulatoryDatabase = true;
      };

      services.fprintd.enable = true;
      zramSwap.enable = true;

      nix-mineral = {
        enable = false;
        settings = {
          kernel = {
            only-signed-modules = true;
            lockdown = true;

            cpu-mitigations = "smt-on";
          };
        };
        filesystems = {
          enable = false;
        };

        extras = {
          kernel = {
            intelme-kmodules = false;
          };

          system = {
            secure-chrony = true;
            lock-root = true;
          };
        };
      };
    };
}
