{
  flake.modules.homeManager.desktop =
    { pkgs, ... }:
    {
      gtk = {
        enable = true;
        theme = {
          name = "Colloid-Dark-Catppuccin";
          package = pkgs.colloid-gtk-theme.override {
            #size = "compact";
            tweaks = [
              "catppuccin"
            ];
            colorVariants = [ "dark" ];
          };
        };
        iconTheme = {
          name = "colloid-icon-theme";
          package = pkgs.colloid-icon-theme;
        };
      };
      qt = {
        enable = true;
        platformTheme.name = "kvantum";
        style = {
          name = "kvantum";
          package = pkgs.catppuccin-kvantum.override {
            variant = "mocha";
            accent = "lavender";
          };
        };
      };
      catppuccin = {
        enable = true;
        accent = "lavender";
        nvim.enable = false;
      };
    };
}
