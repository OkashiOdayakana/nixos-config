{ config, ... }:

{

  sops.secrets.wireless-env = { };
  services.resolved.enable = true;
  # Hostname.
  networking.hostName = "okashitop";
  systemd.network.wait-online.enable = false;
  networking.networkmanager = {
    enable = true;
    dns = "systemd-resolved";
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
            dns-search = "";
            method = "auto";
          };
          ipv6 = {
            addr-gen-mode = "stable-privacy";
            dns-search = "";
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

}
