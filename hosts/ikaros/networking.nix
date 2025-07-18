{
  flake.modules.nixos.host_ikaros =
    { ... }:
    {
      networking = {
        hostName = "ikaros";
        hostId = "2437e247";
        nameservers = [
          "9.9.9.9#dns.quad9.net"
          "2620:fe::9#dns.quad9.net"
        ];
        firewall = {
          allowedTCPPorts = [
            80
	    179
            443
          ];
          allowedUDPPorts = [ 443 ];
        };
      };
      systemd.network = {
        enable = true;
        networks."10-wan" = {
          matchConfig.MACAddress = "8c:dc:d4:ae:42:b1";
          address = [
            "207.174.104.41/24"
            "2602:fd50:1a1:41::2/64"
          ];
          routes = [
            { Gateway = "2602:fd50:1a1:41::1"; }
            { Gateway = "207.174.104.1"; }
          ];
        };
      };

    };
}
