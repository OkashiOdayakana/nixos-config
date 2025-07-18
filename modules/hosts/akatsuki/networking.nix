{
  flake.modules.nixos.host_akatsuki =
    { config, ... }:
    {
      sops.secrets.wg-priv = { };

      networking = {
        hostId = "592d177f";
        nameservers = [
          "9.9.9.9#dns.quad9.net"
          "2620:fe::9#dns.quad9.net"
        ];
        firewall = {
          allowedTCPPorts = [
            80
            443
            179
          ];
          allowedUDPPorts = [
            443
            51820
          ];
        };
      };

      systemd = {
        services.systemd-networkd.serviceConfig.LoadCredential = [
          "network.wireguard.private.30-wg0:${config.sops.secrets.wg-priv.path}"
        ];

        network = {
          enable = true;
          netdevs = {
            "10-dummy0" = {
              netdevConfig = {
                Kind = "dummy";
                Name = "dummy0";
              };
            };
            "30-wg0" = {
              netdevConfig = {
                Kind = "wireguard";
                Name = "wg0";
                MTUBytes = "1300";
              };
              wireguardConfig = {
                ListenPort = 51820;
                RouteTable = "main";
              };
              wireguardPeers = [
                {
                  PublicKey = "bBur/dym/lFpftsrVKL7zpxA6ZMhm92VcNG7LRPCzXs=";
                  AllowedIPs = [ "2602:f61a:b0::/44" ];
                }
              ];
            };
          };
          networks = {
            "20-wan" = {
              matchConfig.MACAddress = "bc:24:11:27:80:f1";
              address = [
                "207.167.121.27/24"
                "2602:fbf5:1::27/48"
              ];
              routes = [
                { Gateway = "2602:fbf5:1::1"; }
                { Gateway = "207.167.121.1"; }
              ];
              #linkConfig.RequiredForOnline = "routable";
            };
            "20-nvix" = {
              matchConfig.MACAddress = "bc:24:11:1c:da:31";
              address = [
                "149.112.60.40/24"
                "2001:504:125:e2::40/64"
              ];
              networkConfig = {
                IPv6AcceptRA = false;
              };
              #linkConfig.RequiredForOnline = "routable";
            };
            "25-dummy0" = {
              matchConfig.Name = "dummy0";
              address = [
                "2602:f61a:f02::b00b/48"
              ];
            };
            "35-wg0" = {
              matchConfig.Name = "wg0";
              address = [ "2602:f61a:b0::1/44" ];
              networkConfig = {
                IPv6Forwarding = true;
              };
            };
          };
        };
      };
    };
}
