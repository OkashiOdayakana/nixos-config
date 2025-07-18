{
  flake.modules.nixos.desktop_gnome =
    { pkgs, ... }:
    {
      services.displayManager.gdm.enable = true;
      services.desktopManager.gnome.enable = true;

      environment.systemPackages = with pkgs; [
        sysprof
        gnomeExtensions.blur-my-shell
        gnomeExtensions.just-perfection
        gnomeExtensions.arc-menu
        gnomeExtensions.appindicator
      ];
      services.sysprof.enable = true;
      services.udev.packages = [ pkgs.gnome-settings-daemon ];

      catppuccin.enable = true;
    };
}
