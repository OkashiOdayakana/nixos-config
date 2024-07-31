{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    (chromium.override {
      commandLineArgs = [
        "--enable-features=VaapiVideoDecodeLinuxGL"
        "--ignore-gpu-blocklist"
        "--enable-zero-copy"
      ];
    })
  ];
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
