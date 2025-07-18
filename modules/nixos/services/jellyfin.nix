{
  flake.modules.nixos.jellyfin =
    { pkgs, ... }:
    {
      nixpkgs.config.packageOverrides = pkgs: {
        vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
      };
      hardware.graphics = {
        enable = true;
        extraPackages = with pkgs; [
          intel-media-driver
          intel-vaapi-driver
          vaapiVdpau
          intel-compute-runtime
          vpl-gpu-rt
        ];
      };
      environment.systemPackages = with pkgs; [
        jellyfin
        jellyfin-web
        jellyfin-ffmpeg
      ];

      services.jellyfin.enable = true;
      users.users."jellyfin".extraGroups = [ "render" ];
      users.groups.media.members = [ "jellyfin" ];

      services.caddy.reverseProxies."jf.okashi-lan.org".port = 8096;
    };

}
