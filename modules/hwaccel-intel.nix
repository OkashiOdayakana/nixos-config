{ pkgs, ... }:
{
  nixpkgs.config.packageOverrides = pkgs: {
    intel-vaapi-driver = pkgs.intel-vaapi-driver.override { enableHybridCodec = true; };
    ffmpeg_7-full = pkgs.ffmpeg_7-full.override {
      withVpl = true;
      withMfx = false;
    };
  };
  #environment.systemPackages = with pkgs; [ ffmpeg_7-full ];

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver # LIBVA_DRIVER_NAME=iHD
      intel-vaapi-driver # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
      libvdpau-va-gl
    ];
  };
}
