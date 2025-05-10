{ lib, ... }:

{
  networking.useDHCP = lib.mkForce false;
  systemd.network.enable = true;
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

  services.resolved = {
    enable = true;
    dnssec = "true";
    #domains = [ "~." ];
    dnsovertls = "true";
  };

  # Hostname.
  networking.hostName = "okashitnas";
  networking.firewall.interfaces.podman0.allowedTCPPorts = [ 443 ];
  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [
    22
    80
    443
    3030
    21063
    21064
    8555
    8080
    8081
    3493
    1812
    1883
  ];
  networking.firewall.allowedUDPPorts = [
    5353
    8555
    10001
    443
    1812
  ];
}
