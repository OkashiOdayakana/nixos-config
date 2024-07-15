# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ ... }:
{
  imports = [
    # Imported modules
    ../../modules/system.nix
    ../../modules/yubikey-gpg.nix
    ../../modules/ssh.nix
    ../../modules/router

    ../../modules/node_exporter.nix
    ../../modules/promtail.nix

    ./impermenance.nix
    ./disk-config.nix
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    # Needed for my GPS (for NTP)
    kernelModules = [ "gnss-ubx" ];
  };
  #  fileSystems = {
  #    "/nix".neededForBoot = true;
  #    "/persist".neededForBoot = true;
  #  };

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 8 * 1024;
    }
  ];
}
