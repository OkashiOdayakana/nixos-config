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
      #      "networkmanager"
      "wheel"
      #      "video"
      #      "render"
      #      "audio"
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

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Use sudo-rs instead of default sudo.
  security.sudo.enable = false;
  security.sudo-rs = {
    enable = true;
    execWheelOnly = true;
  };
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
    nixd
    vim
  ];

  # Use nftables instead of iptables.
  networking.nftables.enable = true;

  # Use ZSH
  programs.zsh = {
    enable = true;
    syntaxHighlighting.enable = true;
  };
  users.defaultUserShell = pkgs.zsh;

  services.udev.packages = [
    pkgs.yubikey-personalization
    pkgs.libu2f-host
  ];

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
        # Workaround for https://github.com/NixOS/nix/issues/9574
        nix-path = config.nix.nixPath;
        # Optimize store
        auto-optimise-store = true;

        trusted-users = [
          "root"
          "@wheel"
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
