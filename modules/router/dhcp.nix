{ config, ... }:
{
  services.kea.dhcp4 = {
    enable = true;
    settings = {
      interfaces-config = {
        interfaces = [ "enp1s0f0" ];
      };
      lease-database = {
        name = "/var/lib/kea/dhcp4.leases";
        persist = true;
        type = "memfile";
      };
      option-data = [
        {
          name = "domain-name-servers";
          data = "192.168.1.1";
          always-send = true;
        }
        {
          name = "routers";
          data = "192.168.1.1";
        }
        {
          name = "domain-name";
          data = "lan";
        }
      ];

      #rebind-timer = 2000;
      #renew-timer = 1000;
      valid-lifetime = 86400;

      subnet4 = [
        {
          pools = [ { pool = "192.168.1.11 - 192.168.1.230"; } ];
          subnet = "192.168.1.0/24";
          id = 1;
          reservations = [
            {
              hw-address = "e4:1d:2d:dd:69:f0";
              ip-address = "192.168.1.5";
            }

          ];
        }
      ];
    };
  };
}
