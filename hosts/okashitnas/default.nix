# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ config, pkgs, ... }:
{
  imports = [
    # Imported modules
    ../../modules/system.nix
    ../../modules/hwaccel-intel.nix
    ../../modules/yubikey-gpg.nix
    ../../modules/ssh.nix
    #../../modules/cloudflared.nix
    ../../modules/ddns.nix
    ../../modules/chronyc.nix
    # Include the results of the hardware scan.
    ./hardware-configuration.nix

    # Import containers
    ../../services/iot
    ../../services/media-nas
    ../../services/stats
    ../../services/caddy.nix
    ../../services/backup/vaultwarden.nix
    ../../services/backup/nextcloud.nix
    ../../services/backup/restic.nix
    ./postgresql.nix

    # System-specific configs
    ./disk-config.nix
    ./services.nix
    ./networking.nix
  ];

  boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.requestEncryptionCredentials = false;
  boot.zfs.forceImportRoot = false;
  networking.hostId = "613a57b3";

  boot.zfs.extraPools = [ "Nas-main" ];
  boot.kernelParams = [ "i915.enable_guc=3" ];

  # User things for NAS HDD access
  users.groups.media.members = [
    "transmission"
    "jellyfin"
    "sonarr"
    "radarr"
  ];

  programs.tmux.enable = true;
}
