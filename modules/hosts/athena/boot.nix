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

        kernel.sysctl = {
          "vm.swappiness" = 180;
          "vm.watermark_boost_factor" = 0;
          "vm.watermark_scale_factor" = 125;
          "vm.page-cluster" = 0;
        };

        kernelPackages = lib.mkForce pkgs.linuxPackages_zen;

        extraModprobeConfig = ''

          options cfg80211 ieee80211_regdom="US"
        '';
      };
    };
}
