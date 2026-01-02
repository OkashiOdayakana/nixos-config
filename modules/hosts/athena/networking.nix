{
  flake.modules.nixos.host_athena =
    { config, ... }:
    {
      systemd.network.wait-online.enable = false;

      # Hostname.
      networking = {
        hostName = "athena";

        networkmanager = {
          wifi = {
            #backend = "iwd";
            macAddress = "stable-ssid";
          };

        };

      };
    };

}
