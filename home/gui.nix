{ pkgs, ... }:
{

  imports = [
    ./librewolf.nix
    ./neovim.nix
    ./firefox.nix
    ./waybar.nix
  ];

  services.swaync.enable = true;
  programs.swaylock.enable = true;
  services = {
    swayidle = {
      enable = true;
      package = pkgs.swayidle;
      timeouts = [
        {
          timeout = 180;
          command = "${pkgs.libnotify}/bin/notify-send 'Locking in 5 seconds' -t 5000";
        }

        {
          timeout = 185;
          command = "${pkgs.swaylock-effects}/bin/swaylock";
        }

        {
          timeout = 190;
          command = "${pkgs.sway}/bin/swaymsg 'output * dpms off'";
          resumeCommand = "${pkgs.sway}/bin/swaymsg 'output * dpms on'";
        }

        {
          timeout = 195;
          command = "${pkgs.systemd}/bin/systemctl suspend";
        }
      ];
      events = [
        {
          event = "before-sleep";
          command = "${pkgs.swaylock-effects}/bin/swaylock";
        }
      ];
    };
  };
  services.swayosd.enable = true;

  home.pointerCursor = {
    name = "phinger-cursors-dark";
    package = pkgs.phinger-cursors;
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };
  gtk = {
    enable = true;
    theme = {
      name = "Colloid-Blue-Catppuccin-Dark";
      package = pkgs.colloid-gtk-theme;
    };
  };
  qt = {
    enable = true;
    platformTheme.name = "kvantum";
    style.name = "kvantum";
  };
  catppuccin.enable = true;
  catppuccin.nvim.enable = false;
  home.packages = with pkgs; [
    nerd-fonts.blex-mono
    nerd-fonts.iosevka
    delta
    chafa
    nerd-fonts.symbols-only
    swaybg
    xwayland-satellite
  ];

  fonts.fontconfig.enable = true;

  services.arrpc = {
    enable = true;
  };

  programs.wezterm = {
    enable = true;
    extraConfig = ''
          local config = {
              font = wezterm.font 'Iosevka Nerd Font',
              use_fancy_tab_bar =  true,
              color_scheme = "Catppuccin Mocha", -- or Macchiato, Frappe, Latte
              window_frame = {
                  active_titlebar_bg = '#181825',
                  inactive_titlebar_bg = '#1e1e2e',
              },
              colors = {
                tab_bar = {
                    -- The color of the inactive tab bar edge/divider
                    inactive_tab_edge = '#1e1e2e',
                    active_tab = {
                        bg_color = '#11111b',
                        fg_color = '#cdd6f4',
                    },
                    inactive_tab = {
                        bg_color = '#11111b',
                        fg_color = '#cdd6f4',
                    },
                    new_tab = {
                        bg_color = '#11111b',
                        fg_color = '#cdd6f4',
                    },
                },
              }
          }
      return config
    '';
  };

}
