# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  imports = [
    # Imported modules
    ../../modules/system.nix
    ../../modules/yubikey-gpg.nix
    ../../modules/ssh.nix

    #../../services/nginx.nix
    #../../services/email/stalwart.nix

    #./hardware-configuration.nix
    ./disk-config.nix
    ./networking.nix
  ];
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.supportedFilesystems = [ "zfs" ];
  #boot.zfs.requestEncryptionCredentials = false;
  #boot.zfs.forceImportRoot = false;
  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 32 * 1024;
    }
  ];
}
