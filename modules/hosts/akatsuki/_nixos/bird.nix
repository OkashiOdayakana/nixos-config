{
  services.bird = {
    enable = true;
    config = ''
      filter mynet_v6 {
          if net ~ 2602:F61A::/36 then accept;
          reject;
      }
      router id 207.167.121.27;
      protocol device {
          scan time 5;
      }

      protocol direct {
          interface "dummy*";
          ipv6;
      }
      protocol kernel {
          ipv6 { 
              export filter {
                if source !~ [RTS_STATIC, RTS_BGP] then reject;
                krt_prefsrc = 2602:f61a:f02::b00b;
                accept;
              };
          };
          learn;
      }

      protocol static {
          ipv6;
          route 2602:f61a:b0::/44 via "wg0";
      }

      roa4 table roa_v4;
      roa6 table roa_v6;

      function is_v4_rpki_invalid () {
          return roa_check(roa_v4, net, bgp_path.last_nonaggregated) = ROA_INVALID;
      }

      function is_v6_rpki_invalid () {
          return roa_check(roa_v6, net, bgp_path.last_nonaggregated) = ROA_INVALID;
      }

      protocol rpki routinator1 {
          roa4 	{ table roa_v4; };
          roa6 { table roa_v6; };
          remote "fd7a:115c:a1e0::6201:8f40" port 3323;
          retry keep 90;
          refresh keep 900;
          expire keep 172800;
      }

      protocol bgp haylin_v6 {
          local as 401767;
          neighbor 2602:fbf5:1::1 as 923;
          ipv6 {
              import filter {
                  if net ~ 2602:fbf5::/40 then reject;
                  if is_v6_rpki_invalid() then reject;
                  accept;
              };
              export filter mynet_v6;
          };
      }

      protocol bgp nvix_v6 {
          local as 401767;
          neighbor 2001:504:125:e2::2 as 62768;
          ipv6 {
              import filter {
                  if net ~ 2602:fbf5::/40 then reject;
                  if is_v6_rpki_invalid() then reject;
                  accept;
              };
              export filter mynet_v6;
          };
      }
    '';
  };
}
