{
  flake.modules.nixos.desktop_kde =
    { pkgs, ... }:
    {
      xdg.portal = {
        enable = true;
        extraPortals = with pkgs; [
          kdePackages.xdg-desktop-portal-kde
        ];
      };

      services.displayManager.sddm = {
        enable = true;
        wayland = {
          enable = true;
          #       compositor = "kwin";
        };
      };
      services.xserver.displayManager.lightdm.enable = false;
      services.desktopManager.plasma6.enable = true;

      environment.systemPackages = with pkgs; [
        kdePackages.breeze-gtk
        kdePackages.breeze-icons
        kdePackages.breeze
      ];

      qt = {
        enable = true;
        platformTheme = "kde";
      };

    };
}
