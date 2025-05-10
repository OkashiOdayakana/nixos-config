{ pkgs, ... }:
{

  imports = [
    ./librewolf.nix
    ./neovim.nix
    ./firefox.nix
  ];

  home.pointerCursor = {
    name = "phinger-cursors-dark";
    package = pkgs.phinger-cursors;
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };

  home.packages = with pkgs; [
    nerd-fonts.blex-mono
    delta
    chafa
    nerd-fonts.symbols-only
  ];

  fonts.fontconfig.enable = true;

  services.arrpc = {
    enable = true;
  };
  programs.kitty = {
    enable = true;
    themeFile = "Catppuccin-Mocha";

    extraConfig = ''
      symbol_map U+e000-U+e00a,U+ea60-U+ebeb,U+e0a0-U+e0c8,U+e0ca,U+e0cc-U+e0d4,U+e200-U+e2a9,U+e300-U+e3e3,U+e5fa-U+e6b1,U+e700-U+e7c5,U+f000-U+f2e0,U+f300-U+f372,U+f400-U+f532,U+f0001-U+f1af0 Symbols Nerd Font Mono
      symbol_map U+2600-U+26FF Noto Color Emoji
    '';
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
