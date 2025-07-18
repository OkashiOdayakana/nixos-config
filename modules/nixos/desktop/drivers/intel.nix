{
  flake.modules.nixos.graphics_intel =
    { pkgs, ... }:
    {
      services.xserver.videoDrivers = [ "modesetting" ];
      hardware.graphics = {
        enable = true;
        extraPackages = with pkgs; [
          intel-media-driver
          intel-ocl
          intel-vaapi-driver
          vpl-gpu-rt
        ];
      };
    };
}
