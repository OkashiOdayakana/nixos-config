# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, lib, ... }:

{
  imports = [
    # Imported modules
    ../../modules/system.nix
    ../../modules/laptop.nix
    ../../modules/hwaccel-intel.nix
    ../../modules/desktop/kde
    ../../modules/desktop/apps/chromium.nix
    ../../modules/dev/go.nix
    ../../modules/yubikey-gpg.nix
    # Include the results of the hardware scan.
    ./hardware-configuration.nix

    ./networking.nix
    ./disk-config.nix
  ];
  catppuccin.accent = "blue";
  catppuccin.enable = true;

  sops.secrets."hosts/okashitop/password".neededForUsers = true;
  users.mutableUsers = false;

  # Enable tailscale.
  services.tailscale.enable = true;

  boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;
  #boot.kernelPackages = pkgs.linuxPackages_latest;
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
    inter
  ];
  nixpkgs.config.packageOverrides = prev: {
    ffmpeg_7-full = prev.jellyfin-ffmpeg.overrideAttrs (_: {
      withVpl = true;
    });
  };
  environment.systemPackages = with pkgs; [
    vesktop
    keepassxc
    clang
    spotify-player
    sbctl
    tpm2-tss
    rbw
    rofi-rbw-wayland
  ];

  # Bootloader.
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.enable = lib.mkForce false;

  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/etc/secureboot";
  };

  boot.initrd.systemd.enable = true;
  services.fwupd.enable = true;
  boot.resumeDevice = "/dev/disk/by-uuid/9b29c9ea-c366-43bb-9944-7aa35a6da1df";
  boot.kernelParams = [
    "resume_offset=533760"
    "mem_sleep_default=deep"
  ];
  systemd.sleep.extraConfig = ''
    [Sleep]
    HibernateMode=shutdown
  '';
}
