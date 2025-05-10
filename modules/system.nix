{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
let
  username = "okashi";
in
{
  sops.secrets.okashi-pwd = {
    sopsFile = ../secrets/okashi-pwd;
    format = "binary";
  };
  sops.secrets.okashi-pwd.neededForUsers = true;
  # Initialize user
  users.users."${username}" = {
    isNormalUser = true;
    description = "okashi";
    extraGroups = [
      "networkmanager"
      "wheel"
      "video"
      "render"
      "audio"
    ];
    hashedPasswordFile = config.sops.secrets.okashi-pwd.path;
  };

  users.mutableUsers = false;
  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  environment.enableAllTerminfo = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    git
    curl
    wget
    htop
    lm_sensors
    wireguard-tools
    usbutils
    pciutils
    gnupg
    vim
    dig
    openssl
    conntrack-tools
    libgcc
    nixd
    uutils-coreutils-noprefix
  ];

  # Use nftables instead of iptables.
  networking.nftables.enable = true;

  # Use ZSH
  programs.zsh = {
    enable = true;
    syntaxHighlighting.enable = true;
    autosuggestions.enable = true;
  };
  users.defaultUserShell = pkgs.zsh;

  services.udev.packages = [
    pkgs.yubikey-personalization
    pkgs.libu2f-host
  ];

  security.sudo.enable = lib.mkForce false;
  security.sudo-rs = {
    enable = true;
    execWheelOnly = true;
  };
  system.rebuild.enableNg = true;

  nix =
    let
      flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
    in
    {
      settings = {
        # Enable flakes and new 'nix' command
        experimental-features = "nix-command flakes";
        # Opinionated: disable global registry
        flake-registry = "";
        # Optimize store
        auto-optimise-store = true;

        trusted-users = [
          "root"
          "@wheel"
          "okashi"
        ];

        substituters = [
          "http://binary.okashi-lan.org"
          "https://nix-community.cachix.org"
          "https://cache.nixos.org"
        ];
        trusted-public-keys = [
          "binary.okashi-lan.org-1:G5qpKfqb77h2ET4OirQC+iquOBnNyYs7NbUH/63M+hs="
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        ];
      };

      # Garbage collection
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 30d";
      };

      # Opinionated: disable channels
      channel.enable = false;

      # Opinionated: make flake registry and nix path match flake inputs
      registry = lib.mapAttrs (_: flake: { inherit flake; }) flakeInputs;
      nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;

    };

  system.stateVersion = "24.05";
}
