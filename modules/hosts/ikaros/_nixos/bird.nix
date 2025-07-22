{ ... }:
{
  services.bird = {
    enable = true;
    config = ''
            filter mynet_v6 {
              if net ~ 2602:F61A::/36 then accept;
            }

            router id 207.174.104.41;
            protocol device {
              scan time 5;
            }

            protocol static static6_bgp {
      	ipv6;
      	route 2602:f61a:f01::/48 reject;
            }

            filter bgp6_out {
               if proto = "static6_bgp" then accept;
               reject;
            }

            protocol bgp neighbor_v4_2 {
              local as 401767;
              neighbor 2602:fd50:1a1:41::1 as 835;
              ipv6 {
                import none;
                export filter bgp6_out;
              };
            }
    '';
  };
}
