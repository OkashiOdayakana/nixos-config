{ ... }:
{
  services.thermald.enable = true;
  hardware.intel-gpu-tools.enable = true;

  services.power-profiles-daemon.enable = true; # ppd, not default
  networking.networkmanager.enable = true;

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
