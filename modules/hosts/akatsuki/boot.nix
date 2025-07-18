{
  flake.modules.nixos.host_akatsuki =
    { lib, ... }:
    {
      boot = {
        loader.systemd-boot.enable = lib.mkForce true;
        initrd.systemd.enable = true;

        kernel.sysctl = {
          "net.ipv4.ip_forward" = true;
          "net.ipv6.conf.all.forwarding" = true;
        };
      };
    };
}
