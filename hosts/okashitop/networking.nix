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
		"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICFzUJd+GxUUCF4CHw8/iNdtCPxXryB5YddAOOKdKJqb"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICg0LR/wRp0hvyYV1emWVWdIsG5nOFdGg9U9N/HON23I"
	];
	networking.firewall.allowedTCPPorts = [ 22 ];

}
