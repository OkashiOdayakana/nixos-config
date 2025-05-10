{ pkgs, ... }:
{

  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };
  environment.gnome.excludePackages =
    (with pkgs; [
      gnome-photos
      gnome-tour
    ])
    ++ (with pkgs.gnome; [
      cheese # webcam tool
      gnome-music
      epiphany # web browser
      geary # email reader
      gnome-characters
      totem # video player
      tali # poker game
      iagno # go game
      hitori # sudoku game
      atomix # puzzle game
    ]);

  nixpkgs.overlays = [
    # GNOME 46: triple-buffering-v4-46
    (final: prev: {
      gnome = prev.gnome.overrideScope (
        gnomeFinal: gnomePrev: {
          mutter = gnomePrev.mutter.overrideAttrs (old: {
            src = pkgs.fetchFromGitLab {
              domain = "gitlab.gnome.org";
              owner = "vanvugt";
              repo = "mutter";
              rev = "triple-buffering-v4-46";
              hash = "sha256-fkPjB/5DPBX06t7yj0Rb3UEuu5b9mu3aS+jhH18+lpI=";
            };
          });
        }
      );
    })
  ];
  hardware.sensor.iio.enable = true;
  programs.dconf.enable = true;
  programs.firefox = {
    enable = true;
    preferences = {
      "widget.use-xdg-desktop-portal.file-picker" = 1;
    };
  };
  services.pipewire.enable = true;
}
