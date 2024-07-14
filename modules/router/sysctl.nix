{ config, ... }:
{

  boot.kernel.sysctl = {
    # if you use ipv4, this is all you need
    "net.ipv4.conf.all.forwarding" = true;

    # If you want to use it for ipv6
    "net.ipv6.conf.all.forwarding" = 2;
    "net.ipv6.conf.default.forwarding" = 2;
    # source: https://github.com/mdlayher/homelab/blob/master/nixos/routnerr-2/configuration.nix#L52
    # By default, not automatically configure any IPv6 addresses.
    "net.ipv6.conf.all.accept_ra" = 0;
    "net.ipv6.conf.default.accept_ra" = 0;
    "net.ipv6.conf.all.autoconf" = 0;
    "net.ipv6.conf.all.use_tempaddr" = 0;

    # On WAN, allow IPv6 autoconfiguration and tempory address use.
    "net.ipv6.conf.${config.routers.wanIf}.accept_ra" = 2;
    #"net.ipv6.conf.${config.routers.wanIf}.autoconf" = 1;

    "net.ipv4.conf.default.rp_filter" = 1;
    "net.ipv4.conf.${config.routers.wanIf}.rp_filter" = 1;
    "net.ipv4.conf.${config.routers.lanIf}.rp_filter" = 0;
  };
}
