{
  flake.modules.nixos.host_athena =
    { lib, ... }:
    {
      nix-mineral = {
        enable = true;
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
