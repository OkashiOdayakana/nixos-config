{
  flake.modules.nixos.podman =
    { pkgs, lib, ... }:
    {
      virtualisation = {
        podman = {
          enable = true;
          extraPackages = [ pkgs.nftables ];
          autoPrune = {
            enable = true; # Periodically prune Podman Images not in use.
            dates = "weekly";
            flags = [ "--all" ];
          };
          # Required for containers under podman-compose to be able to talk to each other.
          defaultNetwork.settings.dns_enabled = true;
        };
        containers = {
          enable = true;
          containersConf.settings.network.network_backend = lib.mkDefault "netavark";
          containersConf.settings.network.firewall_driver = lib.mkDefault "nftables";
        };
      };
    };
}
