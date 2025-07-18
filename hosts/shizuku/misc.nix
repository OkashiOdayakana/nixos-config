{
  flake.modules.nixos.host_shizuku =
    { pkgs, ... }:
    {
      services.redis.package = pkgs.valkey;
      services.tailscale.useRoutingFeatures = "server";
    };
}
