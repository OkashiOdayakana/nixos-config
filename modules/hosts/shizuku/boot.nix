{ lib, ... }:
{
  flake.modules.nixos.host_shizuku.boot = {
    kernel.sysctl = {
      "net.ipv4.ip_forward" = 1;
      "net.ipv6.conf.all.forwarding" = 1;
      "net.ipv6.conf.eth0.accept_ra" = 2;
      "net.core.rmem_max" = 67108864;
      "net.core.wmem_max" = 67108864;
      "net.ipv4.tcp_rmem" = "4096 87380 33554432";
      "net.ipv4.tcp_wmem" = "4096 65536 33554432";
      "net.ipv4.tcp_congestion_control" = "bbr";
      "net.ipv4.tcp_tw_reuse" = 1;
    };
    kernelParams = [
      "amd_pstate=active"
      #      "microcode.amd_sha_check=off"
    ];

    loader.systemd-boot.enable = lib.mkForce false;
    initrd.systemd.enable = true;

    lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
    };

    supportedFilesystems = [
      "bcachefs"
      "nfs"
    ];

  };
}
