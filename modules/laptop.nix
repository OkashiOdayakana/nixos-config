{ ... }:
{
  services.thermald.enable = true;
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
