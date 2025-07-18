{
  flake.modules.homeManager.terminal =
    { lib, pkgs, ... }:
    {
      catppuccin.wezterm.enable = lib.mkForce false;
      home.packages = with pkgs; [ wezterm ];
      programs.wezterm = {
        enable = true;
        extraConfig = ''
          return {
              font = wezterm.font("Iosevka Nerd Font Mono"),
              color_scheme = "Catppuccin Mocha",

              use_fancy_tab_bar = false,
              colors = {
                  tab_bar = {
                    background = "#1e1e2e"
                  }
              }
           }
        '';
      };
    };
}
