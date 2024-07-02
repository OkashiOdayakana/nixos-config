{ config, pkgs, lib, ... }:

{

# Hostname.
	networking.hostName = "okashitop";
	networking.networkmanager = {
		enable = true;
		ensureProfiles.profiles = {
			home-wifi = {
				connection = {
					id = "home-wifi";
					permissions = "";
					type = "wifi";
				};
				ipv4 = {
					dns-search = "";
					method = "auto";
				};
				ipv6 = {
					addr-gen-mode = "stable-privacy";
					dns-search = "";
					method = "auto";
				};
				wifi = {
					mac-address-blacklist = "";
					mode = "infrastructure";
					ssid = "TargetWiFi";
				};
				wifi-security = {
					auth-alg = "open";
					key-mgmt = "sae";
					psk = "***REMOVED***";
				};
			};
		};

	};
	services.openssh = {
		enable = true;
# require public key authentication for better security
		settings.PasswordAuthentication = false;
		settings.KbdInteractiveAuthentication = false;
settings.PermitRootLogin = "yes";
	};
	users.users."root".openssh.authorizedKeys.keys = [
		"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICFzUJd+GxUUCF4CHw8/iNdtCPxXryB5YddAOOKdKJqb" # content of authorized_keys file
# note: ssh-copy-id will add user@your-machine after the public key
# but we can remove the "@your-machine" part
	];
	networking.firewall.allowedTCPPorts = [ 22 ];

}
