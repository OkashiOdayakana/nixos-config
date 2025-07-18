{
  flake.modules.nixos.host_ikaros =
    {lib, ...}:
   {
    boot = {
          loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = lib.mkForce false;
      timeout = 0;
    };

    initrd = {
      systemd.enable = true;
    };

    lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
    };
    };
  };
}
