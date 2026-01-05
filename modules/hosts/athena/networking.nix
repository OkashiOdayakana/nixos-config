{
  flake.modules.nixos.host_athena =
    { lib, ... }:
    {
      systemd.network.wait-online.enable = false;
      systemd.services.iwd.serviceConfig = {
        LimitNOFILE = 65536;
      };
      # Hostname.
      networking = {
        hostName = "athena";

        wireless.iwd = {
          settings = {
            General = {
              Country = "US";
              AddressRandomization = "network";
            };
            DriverQuirks = {
              PowerSaveDisable = "*";
              DefaultInterface = lib.mkForce "";
            };
          };
        };
        networkmanager = {
          wifi = {
            backend = "iwd";
            macAddress = "stable-ssid";
            powersave = false;
          };

        };

      };
    };

}
