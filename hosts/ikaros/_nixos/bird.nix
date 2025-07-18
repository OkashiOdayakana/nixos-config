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

      protocol direct {
              interface "dummy*";
              ipv6;
      }

      protocol bgp neighbor_v4_2 {
        local as 401767;
        neighbor 2602:fd50:1a1:41::1 as 835;
        ipv6 {
          import none;
          export filter mynet_v6;
        };
      }
    '';
  };
}
