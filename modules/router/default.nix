{ ... }:

{
  imports = [
    ./variables.nix
    ./sysctl.nix
    ./base_network.nix
    ./dhcp.nix
    ./dns.nix
    ./firewall.nix
    ./ntp.nix
    ../hardened.nix
  ];
}
