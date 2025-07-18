{
  flake.modules.nixos.core =
    { lib, pkgs, ... }:
    {
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

      # Use nftables instead of iptables.
      networking.nftables.enable = true;

      boot = {
        tmp = {
          useTmpfs = true;
          tmpfsHugeMemoryPages = "within_size";
        };
        kernelPackages = pkgs.linuxPackages_latest;
      };
      systemd.services.nix-daemon = {
        environment.TMPDIR = "/var/tmp";
      };
      services.fstrim.enable = true;
      networking.useDHCP = lib.mkForce false;

      environment.enableAllTerminfo = true;
    };
}
