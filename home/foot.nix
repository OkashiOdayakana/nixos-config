{pkgs, ...}: let
  catppuccinDrv = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/catppuccin/foot/009cd57bd3491c65bb718a269951719f94224eb7/catppuccin-mocha.conf";
    hash = "sha256-plQ6Vge6DDLj7cBID+DRNv4b8ysadU2Lnyeemus9nx8=";
  };
in {
  programs.foot = {
    enable = true;
    settings = {
      main = {
        box-drawings-uses-font-glyphs = true;
        include = "${catppuccinDrv}";
      };

      scrollback = {
        lines = 10000;
      };

      url = {
        launch = "xdg-open \${url}";
        protocols = "http, https, ftp, ftps, file";
      };

    };
  };
}
