{
  flake.modules.nixos.graphics_amd =
    { pkgs, ... }:
    {
      hardware.graphics = {
        enable = true;
        enable32Bit = true;
      };
      hardware.amdgpu.initrd.enable = true;
    };
}
