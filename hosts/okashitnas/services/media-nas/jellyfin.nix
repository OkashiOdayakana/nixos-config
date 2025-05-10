{ pkgs, ... }:
{
  nixpkgs.config.packageOverrides = pkgs: {
    vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
  };
  hardware.graphics = {
    # hardware.opengl in 24.05
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      intel-vaapi-driver # previously vaapiIntel
      vaapiVdpau
      intel-compute-runtime # OpenCL filter support (hardware tonemapping and subtitle burn-in)
      vpl-gpu-rt # QSV on 11th gen or newer
      intel-media-sdk
    ];
  };
  environment.systemPackages = with pkgs; [
    jellyfin
    jellyfin-web
    jellyfin-ffmpeg
  ];

  # 2. do not forget to enable jellyfin
  services.jellyfin.enable = true;
  users.users."jellyfin".extraGroups = [ "render" ];

  services.caddy.virtualHosts."jf.okashi-lan.org" = {
    extraConfig = ''
      reverse_proxy 127.0.0.1:8096
    '';
  };
}
