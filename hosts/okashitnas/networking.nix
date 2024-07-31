{ ... }:

{
  networking.nameservers = [ "192.168.1.1" ];
  networking.defaultGateway = "192.168.1.1";
  networking.interfaces.enp5s0 = {
    useDHCP = false;
    ipv4.addresses = [
      {
        "address" = "192.168.1.5";
        "prefixLength" = 24;
      }
    ];
  };

  # Hostname.
  networking.hostName = "okashitnas";
  #networking.networkmanager.enable = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [
    22
    80
    443
    3030
    5000
    8082
    8123
    8096
    8099
    8443
    9091
    21063
    21064
    51827
    8555
  ];
  networking.firewall.allowedUDPPorts = [
    5353
    8555
  ];
  networking.nftables.ruleset = ''
    table ip nat {
      chain PREROUTING {
        type nat hook prerouting priority dstnat; policy accept;
        iifname "veth-vpn" tcp dport 9091 dnat to 10.0.0.2:9091
      }
      chain postrouting {
      type nat hook postrouting priority filter; policy accept;
      oifname "veth-vpn" masquerade
      }
    }
  '';
}
