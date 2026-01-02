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
            8428
            9428
            1883
          ];
          allowedUDPPorts = [ 443 ];
        };
      };
      systemd.network = {
        netdevs = {
          "30-br0" = {
            netdevConfig = {
              Kind = "bridge";
              Name = "br0";
              MACAddress = "none";
            };
          };
        };
        networks = {

          "10-uplink" = {
            name = "enp4s0";
            bridge = [ "br0" ];
          };
          "30-br0" = {
            name = "br0";
            networkConfig = {
              # start a DHCP Client for IPv4 Addressing/Routing
              DHCP = "yes";
              # accept Router Advertisements for Stateless IPv6 Autoconfiguraton (SLAAC)
              IPv6AcceptRA = true;
              IPv6PrivacyExtensions = true;

              DNSOverTLS = "opportunistic";

              LLDP = true;
              EmitLLDP = true;
              LLMNR = false;
              # DNS = "fd0a:371b:2c78:1::1#dns.okashi-lan.org";
            };
            ipv6AcceptRAConfig = {
              Token = "prefixstable,309d3c58-53d8-4017-91e6-56bf87a5dc6f";
              #UseDNS = false;
            };
            #dhcpV4Config.UseDNS = false;
            # make routing on this interface a dependency for network-online.target
            #linkConfig.RequiredForOnline = "routable";
          };
        };

        links = {
          "30-br0" = {
            matchConfig = {
              OriginalName = "br0";
            };
            linkConfig = {
              MACAddressPolicy = "none";
              MACAddress = "e4:1d:2d:dd:69:f0";
            };
          };
          "10-uplink" = {
            matchConfig = {
              PermanentMACAddress = "e4:1d:2d:dd:69:f0";

            };
            linkConfig = {
              MACAddressPolicy = "none";
              MACAddress = "e4:1d:2d:dd:69:67";
              Name = "enp4s0";
            };
          };
        };
      };
    };
}
