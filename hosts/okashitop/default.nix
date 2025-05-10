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
    ../../modules/chronyc.nix

    # Include the results of the hardware scan.
    ./hardware-configuration.nix

    ./networking.nix
    ./disk-config.nix
    ./remote-build.nix
  ];

  catppuccin.accent = "blue";
  catppuccin.enable = true;

  sops.secrets."hosts/okashitop/password".neededForUsers = true;

  # Enable tailscale.
  services.tailscale.enable = true;

  nix.settings = {
    system-features = [
      "kvm"
      "big-parallel"
      "nixos-test"
      "benchmark"
      "gccarch-skylake"

    ];
    max-jobs = 4;
  };

  boot.kernelPackages = pkgs.linuxPackages_latest;
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
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

  environment.systemPackages = with pkgs; [
    vesktop
    keepassxc
    clang
    spotify-player
    sbctl
    tpm2-tss
    rbw
    rofi-rbw-wayland
    pinentry-qt
    wireshark-qt
    nodejs_latest
    pnpm
    vscode-fhs
    sops
    ssh-to-age
  ];

  # Bootloader.
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.enable = lib.mkForce false;

  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/etc/secureboot";
  };

  services.hardware.bolt.enable = true;
  boot.initrd.systemd.enable = true;
  services.fwupd.enable = true;

  boot.resumeDevice = "/dev/disk/by-uuid/a869aad5-1f30-4100-a8c0-91ae944c1408";
  boot.kernelParams = [
    "resume_offset=533670"
    "mem_sleep_default=deep"
    "i915.enable_psr=1"
    "i915.enable_dc=1"
  ];
  systemd.sleep.extraConfig = ''
    [Sleep]
    HibernateMode=shutdown
  '';

}
