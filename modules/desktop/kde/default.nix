{ pkgs, ... }:
{
  nixpkgs.config.packageOverrides = pkgs: {
    catppuccin-kde = pkgs.catppuccin-kde.override {
      flavour = [ "mocha" ];
      winDecStyles = [ "classic" ];
    };
  };

  services.xserver.enable = true;
  programs.kdeconnect.enable = true;

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
  hardware.pulseaudio.enable = false;
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

  hardware.bluetooth.enable = true;
  hardware.sensor.iio.enable = true;

  environment.systemPackages = with pkgs; [
    catppuccin-kde
    papirus-icon-theme
    kdePackages.breeze-gtk
    kdePackages.breeze-icons
    kdePackages.breeze
    catppuccin-cursors # Mouse cursor theme
    catppuccin-papirus-folders # Icon theme, e.g. for pcmanfm-qt
    papirus-folders # For the catppucing stuff work
  ];

  qt = {
    enable = true;
    platformTheme = "kde";
  };

  catppuccin.flavor = "mocha";

  #catppuccin.enable = true;
}
