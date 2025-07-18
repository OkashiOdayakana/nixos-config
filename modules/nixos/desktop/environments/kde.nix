{
  flake.modules.nixos.desktop_kde =
    { pkgs, ... }:
    {
      nixpkgs.config.packageOverrides = pkgs: {
        catppuccin-kde = pkgs.catppuccin-kde.override {
          flavour = [ "mocha" ];
          winDecStyles = [ "classic" ];
        };
      };

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
          # compositor = "kwin";
        };
      };
      services.xserver.displayManager.lightdm.enable = false;
      services.desktopManager.plasma6.enable = true;

      environment.systemPackages = with pkgs; [
        catppuccin-kde
        kdePackages.breeze-gtk
        kdePackages.breeze-icons
        kdePackages.breeze
        catppuccin-cursors # Mouse cursor theme
      ];

      qt = {
        enable = true;
        platformTheme = "kde";
      };

      catppuccin.enable = true;

    };
}
