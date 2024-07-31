{ config, ... }:
{
  networking = {
    hostName = "Router";
    useNetworkd = true;
    useDHCP = false;

    # No local firewall.
    nat.enable = false;
    firewall.enable = false;

    nftables = {
      enable = true;
      #flattenRulesetFile = true;
      #preCheckRuleset = "sed 's/.*devices.*/devices = { lo }/g' -i ruleset.conf";
      #checkRuleset = false;
      ruleset = ''
              flush ruleset 
              define if_wan = ${config.routers.wanIf}
              define if_lan = ${config.routers.lanIf}
              define extifs = { "${config.routers.wanIf}", "${config.routers.lanIf}", vlan5 }
              table inet filter {
                chain input {
                  type filter hook input priority 0; policy drop;

                  iifname { $if_lan } accept comment "Allow local network to access the router"
                  ct state vmap { established : accept, related : accept, invalid : drop }
                  iifname { $if_wan } icmp type { echo-request, destination-unreachable, time-exceeded } counter accept comment "Allow select ICMP"
                  iifname "lo" accept comment "Accept everything from loopback interface"

                  # ICMPv6
                  icmpv6 type {nd-neighbor-solicit,nd-neighbor-advert,nd-router-solicit,
                  nd-router-advert,mld-listener-query,destination-unreachable,
                  packet-too-big,time-exceeded,parameter-problem} accept

                  ip6 nexthdr icmpv6 icmpv6 type echo-request limit rate 1/second accept comment "Accept max 1 ping per second"

                  # DHCPv6
                  udp dport dhcpv6-client udp sport dhcpv6-server counter accept comment "IPv6 DHCP"
                  #iifname { $if_wan } ip6 daddr fe80::/64 udp dport dhcpv6-client accept 

                }
                chain forward {
                  type filter hook forward priority filter; policy drop;
                  ct status dnat accept
                  iifname $if_lan meta l4proto { tcp, udp } th dport 853 drop comment "Early reject DoT"
                  iifname { $if_lan } oifname { $if_wan } accept comment "Allow trusted LAN to WAN"
                  iifname { $if_wan } oifname { $if_lan } ct state { established, related } accept comment "Allow established back to LANs"
                  iifname { $if_lan } oifname { "vlan5" } ip saddr 192.168.1.5 accept comment "Allow HA to IoT vlan"
                  iifname { "vlan5" } oifname { $if_lan } ip daddr 192.168.1.5 accept comment "Allow IoT to HA"
                }
                chain output {
                  type filter hook output priority filter; policy accept;
                }
              }

              table ip nat {
                chain prerouting {
                  type nat hook prerouting priority -150; policy accept;
                  iifname $if_wan tcp dport { 80 } dnat to 192.168.1.5
                  iifname $if_wan tcp dport { 443 } dnat to 192.168.1.5
                  iifname $if_lan meta l4proto { tcp, udp } th dport 53 redirect to 53 comment "Hijack DNS (IPv4)"
                  iifname $if_lan udp dport 123 redirect to 123 comment "Hijack NTP (IPv4)"
                }
                chain postrouting {
                  type nat hook postrouting priority 100; policy accept;
                  oifname $if_wan masquerade
                }
              }
        #      table ip6 nat {
        #        chain prerouting {
        #            type nat hook prerouting priority dstnat; policy accept;
        #            iifname $if_lan meta l4proto { tcp, udp } th dport 53 redirect to 53 comment "Hijack DNS (IPv6)"
        #            iifname $if_lan udp dport 123 redirect to 123 comment "Hijack NTP (IPv6)"
        #        }
        #      }
      '';
    };
  };
}
