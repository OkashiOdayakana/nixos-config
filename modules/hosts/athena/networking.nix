{
  flake.modules.nixos.host_athena =
    { config, ... }:
    {
      sops.secrets.wireless-env = { };
      systemd.network.wait-online.enable = false;

      # Hostname.
      networking = {
        hostName = "athena";
        nameservers = [
          "fd0a:371b:2c78:1::1#dns.okashi-lan.org"
          "10.1.0.1#dns.okashi-lan.org"
        ];
        wireless.iwd = {
          settings = {
            General = {
              AddressRandomization = "network";
            };
          };
        };
        networkmanager = {
          wifi = {
            backend = "iwd";
            macAddress = "stable-ssid";
          };
          connectionConfig."connection.mdns" = true;
          ensureProfiles = {
            environmentFiles = [ config.sops.secrets.wireless-env.path ];
            profiles = {
              home-wifi = {
                connection = {
                  id = "home-wifi";
                  permissions = "";
                  type = "wifi";
                };
                ipv4 = {
                  method = "auto";
                };
                ipv6 = {
                  addr-gen-mode = "stable-privacy";
                  method = "auto";
                };
                wifi = {
                  mac-address-blacklist = "";
                  mode = "infrastructure";
                  ssid = "$HOME_WIFI_SSID";
                };
                wifi-security = {
                  auth-alg = "open";
                  key-mgmt = "sae";
                  psk = "$HOME_WIFI_PSK";
                };
              };
            };
          };
        };

      };
    };

}
