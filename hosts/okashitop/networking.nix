{ ... }:

{

  # Hostname.
  networking.hostName = "okashitop";
  networking.networkmanager = {
    enable = true;
    ensureProfiles.profiles = {
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
          ssid = "TargetWiFi";
        };
        wifi-security = {
          auth-alg = "open";
          key-mgmt = "sae";
          psk = "pantsshitter69!";
        };
      };
    };

  };

}
