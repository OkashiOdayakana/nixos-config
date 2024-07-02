{ config, pkgs, lib, ...}:
{
	programs.firefox = {
		enable = true;
		#nativeMessagingHosts.packages = [ pkgs.plasma6Packages.plasma-browser-integration ];
		preferences = {
			"widget.use-xdg-desktop-portal.file-picker" = 1;
		};
	};
	environment.sessionVariables = {
		MOZ_USE_XINPUT2 = "1";
	};
	xdg = {
		portal = {
			enable = true;
			extraPortals = with pkgs; [
				xdg-desktop-portal-wlr
					xdg-desktop-portal-gtk
			];
		};
	};
}
