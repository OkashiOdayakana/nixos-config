{ pkgs, ... }:
{
  nixpkgs.config.packageOverrides = pkgs: {
    catppuccin-kde = pkgs.catppuccin-kde.override {
      flavour = [ "mocha" ];
      winDecStyles = [ "classic" ];
    };
  };

  services.xserver.enable = true;
  programs.kdeconnect.enable = false;
  programs.firefox.nativeMessagingHosts.ff2mpv = true;
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
      kdePackages.xdg-desktop-portal-kde
    ];
    wlr.enable = true;
  };
  #services.xserver.videoDrivers = [ "modesetting" ];
  # You may need to comment out "services.displayManager.gdm.enable = true;"
  #	services.xserver.displayManager.gdm.enable = false;
  services.displayManager.sddm.enable = true;
  services.xserver.displayManager.lightdm.enable = false;
  services.desktopManager.plasma6.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  environment.plasma6.excludePackages = with pkgs.kdePackages; [ oxygen ];

  programs.dconf.enable = true;
  # Enable sound with pipewire.
  #.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
    wireplumber.enable = true;

  };

  services.pipewire.wireplumber.extraConfig.disableCamera = {
    "monitor.libcamera" = false;
  };
  hardware.bluetooth.enable = true;
  hardware.sensor.iio.enable = true;

  environment.systemPackages = with pkgs; [
    catppuccin-kde
    kdePackages.breeze-gtk
    kdePackages.breeze-icons
    kdePackages.breeze
    #catppuccin-cursors # Mouse cursor theme
  ];

  qt = {
    enable = true;
    platformTheme = "kde";
  };

  catppuccin.flavor = "mocha";

  #catppuccin.enable = true;
}
