{ lib, ... }:
{
  flake.modules.nixos.host_athena.boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = lib.mkForce false;
      timeout = 0;
    };

    initrd = {
      systemd.enable = true;
      #availableKernelModules = [ "i915" ];
    };

    kernelModules = [
      "i915"
      "iwlwifi"
    ];
    lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
      settings = {
        # console-mode = "max";
      };
    };

  };
}
