{
  flake.modules.nixos.core =
    { lib, ... }:
    {
      services.tailscale = {
        enable = true;
        useRoutingFeatures = lib.mkDefault "client";
      };
      systemd.services.tailscaled.environment = { TS_DEBUG_FIREWALL_MODE = "nftables"; };
    };
}
