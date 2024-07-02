# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, ... }:

{
    imports =
        [
# Imported modules
        ../../modules/system.nix
            ../../modules/laptop.nix
            ../../modules/hwaccel-intel.nix
            ../../modules/desktop/kde
            ../../modules/desktop/apps/firefox.nix
            ../../modules/dev/go.nix
            ../../modules/yubikey-gpg.nix
# Include the results of the hardware scan.
            ./hardware-configuration.nix

            ./networking.nix
            ./disk-config.nix
        ];

    boot.supportedFilesystems = [ "bcachefs" ];

    sops.secrets."hosts/okashitop/password".neededForUsers = true;
    users.mutableUsers = false;

    fonts.packages = with pkgs; [
        noto-fonts
            noto-fonts-cjk
            noto-fonts-emoji
            liberation_ttf
            fira-code
            fira-code-symbols
            mplus-outline-fonts.githubRelease
            dina-font
            proggyfonts
            meslo-lgs-nf
    ];
    environment.systemPackages = [
        pkgs.vesktop
        pkgs.keepassxc
    ];

# Bootloader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    swapDevices = [ {
        device = "/var/lib/swapfile";
        size = 16*1024;
    } ];
}
