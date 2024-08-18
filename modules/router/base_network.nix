{ config, ... }:

{

  systemd.services."systemd-networkd".environment.SYSTEMD_LOG_LEVEL = "debug";
  systemd.network = {
    netdevs = {
      "20-vlan5" = {
        netdevConfig = {
          Kind = "vlan";
          Name = "vlan5";
        };
        vlanConfig.Id = 5;
      };
    };
    networks = {
      "30-lan" = {
        matchConfig.Name = config.routers.lanIf;
        address = [ "192.168.1.1/24" ];
        vlan = [ "vlan5" ];
        networkConfig = {
          IPv6SendRA = true;
          DHCPPrefixDelegation = true;
          IPv6DuplicateAddressDetection = 1;
        };
        extraConfig = ''
          [CAKE]
          Bandwidth=920M
          UseRawPacketSize=yes
          FlowIsolationMode=triple
          NAT=yes
        '';
      };
      "40-vlan5" = {
        matchConfig.Name = "vlan5";
        address = [ "192.168.5.1/24" ];
      };
      "10-wan" = {
        matchConfig.Name = config.routers.wanIf;
        networkConfig = {
          # start a DHCP Client for IPv4 Addressing/Routing
          DHCP = true;
          # accept Router Advertisements for Stateless IPv6 Autoconfiguraton (SLAAC)
          IPv6AcceptRA = true;
          IPv6PrivacyExtensions = true;
          # DHCPPrefixDelegation = true;
          #KeepConfiguration = true;
        };
        # This configures the DHCPv6 client part towards the ISPs DHCPv6 server.
        dhcpV6Config = {
          PrefixDelegationHint = "::/56";
          #WithoutRA = "solicit";
          #DUIDType = "uuid";
        };
        ipv6AcceptRAConfig = {
          UseDNS = false;
          DHCPv6Client = "always";
        };
        ipv6SendRAConfig = {
          Managed = true;
        };

        # make routing on this interface a dependency for network-online.target
        linkConfig.RequiredForOnline = "routable";
      };
    };
  };
}
