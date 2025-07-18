{
  flake.modules.nixos.host_shizuku =
    { ... }:
    {
      networking = {
        hostName = "shizuku";
        hostId = "613a57b3";

        firewall = {
          allowedTCPPorts = [
            80
            443
            21064
            1883
          ];
          allowedUDPPorts = [ 443 ];
        };
      };
      systemd.network.networks."10-uplink" = {
        matchConfig.PermanentMACAddress = "e4:1d:2d:dd:69:f0";
        networkConfig = {
          # start a DHCP Client for IPv4 Addressing/Routing
          DHCP = "ipv4";
          # accept Router Advertisements for Stateless IPv6 Autoconfiguraton (SLAAC)
          IPv6AcceptRA = true;
          IPv6PrivacyExtensions = true;

          DNSOverTLS = true;
          LLDP = true;
          EmitLLDP = true;
          LLMNR = false;
          DNS = "fd0a:371b:2c78:1::1#dns.okashi-lan.org";
        };
        ipv6AcceptRAConfig = {
          Token = "prefixstable,309d3c58-53d8-4017-91e6-56bf87a5dc6f";
          UseDNS = false;
        };
        dhcpV4Config.UseDNS = false;
        # make routing on this interface a dependency for network-online.target
        linkConfig.RequiredForOnline = "routable";
      };
    };
}
