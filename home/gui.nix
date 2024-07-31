{ pkgs, ... }:
{

  imports = [
    ./firefox.nix
    ./neovim.nix
  ];

  home.pointerCursor = {
    name = "phinger-cursors-dark";
    package = pkgs.phinger-cursors;
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };

  home.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "IBMPlexMono" ]; })
    delta
    chafa
  ];

  fonts.fontconfig.enable = true;

  services.arrpc = {
    enable = true;
  };
  programs.wezterm = {
    enable = true;
    enableZshIntegration = true;
    extraConfig = ''
          local config = {
              use_fancy_tab_bar =  true,
              font = wezterm.font 'Blex Mono Nerd Font',
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
