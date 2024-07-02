{ config, pkgs, lib, ... }:
let  
catppuccinDrv = pkgs.fetchurl {
	url = "https://raw.githubusercontent.com/catppuccin/foot/009cd57bd3491c65bb718a269951719f94224eb7/catppuccin-mocha.conf";
	hash = "sha256-plQ6Vge6DDLj7cBID+DRNv4b8ysadU2Lnyeemus9nx8=";
};
in
{

	home.pointerCursor = {
		name = "phinger-cursors-light";
		package = pkgs.phinger-cursors;
		size = 32;
		gtk.enable = true;
	};
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
	programs.wezterm = {
		enable = true;
		enableZshIntegration = true;
		extraConfig = ''
			local config = {
				-- ...your existing config
					use_fancy_tab_bar = false,
				color_scheme = "Catppuccin Mocha", -- or Macchiato, Frappe, Latte
			}
		return config
			'';
	};
	home.packages = [
		(pkgs.discord.override {
# remove any overrides that you don't want
		 withOpenASAR = false;
		 withVencord = true;
		 })
	];

}
