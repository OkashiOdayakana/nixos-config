{ config, ... }:
{
  services.dnsmasq = {
    enable = true;
    settings = {
      # don't ever listen to anything on eth0
      port = 5353;
      except-interface = config.routers.wanIf;
      # don't send bogus requests out on the internets
      bogus-priv = true;

      # enable IPv6 Route Advertisements
      enable-ra = true;

      # Construct a valid IPv6 range from reading the address set on the interface. The ::1 part refers to the ifid in dhcp6c.conf. Make sure you get this right or dnsmasq will get confused.
      dhcp-range = [
        "tag:${config.routers.lanIf},::1,constructor:${config.routers.lanIf}, ra-names, 12h"
        "${config.routers.lanIf},192.168.1.12,192.168.1.250,24h"
        "set:5,192.168.5.10,192.168.5.200,255.255.255.0,24h"
      ];

      dhcp-option = [
        "3,0.0.0.0"
        "6,0.0.0.0"
        "42,0.0.0.0"
      ];
      # ra-names enables a mode which gives DNS names to dual-stack hosts which do SLAAC  for  IPv6.
      # Add your local-only LAN domain
      local = "/lan/";

      #  have your simple hosts expanded to domain
      no-hosts = true;

      # set your domain for expand-hosts
      domain = "lan";
      # provide a IPv4 dhcp range too
      # set authoitative mode
      dhcp-authoritative = true;

    };
  };
}
