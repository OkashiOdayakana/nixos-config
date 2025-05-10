{ lib, pkgs, ... }:
{
  imports = [
    # Imported modules
    ../../modules/system.nix
    ../../modules/hwaccel-intel.nix
    ../../modules/yubikey-gpg.nix
    ../../modules/ssh.nix
    ../../modules/chronyc.nix

    # Include the results of the hardware scan.
    ./hardware-configuration.nix

    # Import containers
    ./services
    ./postgresql.nix

    # System-specific configs
    ./disk-config.nix
    ./networking.nix
  ];

  nixpkgs.config.allowBroken = true;

  services.nix-serve = {
    enable = true;
    secretKeyFile = "/var/cache-priv-key.pem";
  };

  services.redis.package = pkgs.valkey;
  nix.settings.system-features = [
    "kvm"
    "nixos-test"
    "benchmark"
    "big-parallel"
    "gccarch-znver3"
  ];

  environment.systemPackages = with pkgs; [
    rclone
    bcachefs-tools
    nvme-cli
    sbctl
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernel.sysctl = {
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
  # Bootloader.
  boot.loader.systemd-boot.enable = lib.mkForce false;

  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
  };
  boot.initrd.systemd.enable = true;

  boot.supportedFilesystems = [ "bcachefs" ];
  systemd.services."bcachefs-mount" = {
    after = [ "local-fs.target" ];
    wantedBy = [ "multi-user.target" ];
    script = ''
      #!${pkgs.runtimeShell} -e
      ${pkgs.keyutils}/bin/keyctl link @u @s
      while [ ! -b /dev/sda ]; do
        echo "Waiting for /dev/sda to become available..."
        sleep 5
      done
      if ${pkgs.util-linux}/bin/mountpoint -q /Nas-main ; then
          echo "/Nas-main already mounted, not remounting."
          exit 0
      else
      ${pkgs.bcachefs-tools}/bin/bcachefs mount -f /etc/bcachefs_keyfile /dev/sda:/dev/disk/by-id/nvme-Samsung_SSD_990_PRO_2TB_S73WNU0XA30502H_1 /Nas-main
      fi
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "root";
    };
  };

  networking.hostId = "613a57b3";

  boot.kernelParams = [
    "amd_pstate=active"
  ];

  powerManagement.enable = true;
  powerManagement.cpuFreqGovernor = "performance";

  services.hardware.bolt.enable = true;

  # User things for NAS HDD access
  users.groups.media.members = [
    "jellyfin"
    "sonarr"
    "radarr"
  ];

  programs.tmux.enable = true;
}
