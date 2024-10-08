# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, lib, ... }:
{
  imports = [
    # Imported modules
    ../../modules/system.nix
    ../../modules/yubikey-gpg.nix
    ../../modules/ssh.nix
    ../../modules/router
    #../../modules/hardened.nix
    ../../modules/node_exporter.nix
    ../../modules/promtail.nix

    ./impermenance.nix
    ./disk-config.nix
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Make sops-nix decrypt files early enough
  sops.age.sshKeyPaths = lib.mkForce [ "/persist/etc/ssh/ssh_host_ed25519_key" ];

  # Bootloader.
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };
  #  fileSystems = {
  #    "/nix".neededForBoot = true;
  #    "/persist".neededForBoot = true;
  #

  boot.kernelPackages = pkgs.linuxPackages_latest;
  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 8 * 1024;
    }
  ];
}
