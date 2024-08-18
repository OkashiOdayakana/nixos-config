{ ... }:
{
  services.thermald.enable = true;
  services.power-profiles-daemon.enable = false;
  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_power";
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

      CPU_MIN_PERF_ON_AC = 0;
      CPU_MAX_PERF_ON_AC = 100;
      CPU_MIN_PERF_ON_BAT = 0;
      CPU_MAX_PERF_ON_BAT = 50;
      CPU_BOOST_ON_AC = 1;
      CPU_BOOST_ON_BAT = 1;

      DISK_DEVICES = "nvme0n1";
      DISK_IOSCHED = "kyber";

      PLATFORM_PROFILE_ON_AC = "performance";
      PLATFORM_PROFILE_ON_BAT = "balanced";
      #Optional helps save long term battery health
      #START_CHARGE_THRESH_BAT0 = 40; # 40 and bellow it starts to charge
      #STOP_CHARGE_THRESH_BAT0 = 80; # 80 and above it stops charging

    };
  };
  networking.networkmanager.enable = true;
  services = {
    syncthing = {
      enable = true;
      user = "okashi";
      dataDir = "/home/okashi/Documents"; # Default folder for new synced folders
      configDir = "/home/okashi/Documents/.config/syncthing"; # Folder for Syncthing's settings and keys
    };
  };

  networking.firewall.allowedTCPPorts = [
    8384
    22000
  ];
  networking.firewall.allowedTCPPortRanges = [
    {
      from = 1714;
      to = 1764;
    } # KDE Connect
  ];

  networking.firewall.allowedUDPPorts = [
    22000
    21027
  ];
  networking.firewall.allowedUDPPortRanges = [
    {
      from = 1714;
      to = 1764;
    } # KDE Connect
  ];

  # Suspend-then-hibernate everywhere
  services.logind = {
    lidSwitch = "suspend-then-hibernate";
    extraConfig = ''
      HandlePowerKey=suspend-then-hibernate
      IdleAction=suspend-then-hibernate
      IdleActionSec=2m
    '';
  };
  systemd.sleep.extraConfig = "HibernateDelaySec=2h";

  users.users.okashi.extraGroups = [ "networkmanager" ];
}
