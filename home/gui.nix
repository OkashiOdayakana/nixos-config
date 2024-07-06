{ pkgs, ... }:
{

    imports = [
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
                -- ...your existing config
                use_fancy_tab_bar = false,
                font = wezterm.font 'Blex Mono Nerd Font',
                color_scheme = "Catppuccin Mocha", -- or Macchiato, Frappe, Latte
            }
        return config
            '';
    };

}
