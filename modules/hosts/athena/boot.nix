{ lib, pkgs, ... }:
{
  flake.modules.nixos.host_athena =
    { pkgs, ... }:
    {
      boot = {
        loader = {
          efi.canTouchEfiVariables = true;
          systemd-boot.enable = lib.mkForce false;

          timeout = 0;
        };

        lanzaboote = {
          enable = true;
          pkiBundle = "/var/lib/sbctl";
        };

        initrd = {
          systemd.enable = true;
        };

        kernelPackages = lib.mkForce pkgs.linuxPackages_zen;
      };
    };
}
