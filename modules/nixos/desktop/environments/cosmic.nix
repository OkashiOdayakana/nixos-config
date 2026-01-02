{ inputs, ... }:
{
  flake.modules.nixos.desktop_cosmic = {

    services = {
      desktopManager.cosmic.enable = true;
      displayManager.cosmic-greeter.enable = true;
      system76-scheduler.enable = true;
    };
  };
}
