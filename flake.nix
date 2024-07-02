{
	description = "Okashi's NixOS flake";

	inputs = {

		nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
		catppuccin.url = "github:catppuccin/nix";
		home-manager = { 
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		sops-nix = {
			url = "github:Mic92/sops-nix";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		disko = {
			url = github:nix-community/disko;
			inputs.nixpkgs.follows = "nixpkgs";
		};
		nixvim = {
			url = "github:nix-community/nixvim";
# If you are not running an unstable channel of nixpkgs, select the corresponding branch of nixvim.
# url = "github:nix-community/nixvim/nixos-24.05";

			inputs.nixpkgs.follows = "nixpkgs";
		};
	};

	outputs = {
		self,
		nixpkgs,
		home-manager,
		sops-nix,
		disko,
		catppuccin,
		nixvim,
		...
	} @ inputs: let
	inherit (self) outputs;
	in {
		nixosConfigurations = {
			okashitnas = nixpkgs.lib.nixosSystem {
				system = "x86_64-linux";
				specialArgs = {inherit inputs outputs;};

				modules = [
					./hosts/okashitnas
						sops-nix.nixosModules.sops
						{
							sops = {
								defaultSopsFile = ./secrets/secrets.yaml;
								age.sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
								secrets = {
									"iot/mqtt/frigate" = {};
									"iot/frigate-cam" = {};
									"iot/mqtt/zigbee2mqtt.yaml" = {};
									"vpn/protonvpn/privateKey" = {};
									"media/transmission/creds.json" = {};
								};
							};
						}

				home-manager.nixosModules.home-manager
				{
					home-manager.useGlobalPkgs = true;
					home-manager.useUserPackages = true;

					home-manager.extraSpecialArgs = inputs;

					home-manager.users.okashi = { 
						imports = [ 
							./home/default.nix
							catppuccin.homeManagerModules.catppuccin
							nixvim.homeManagerModules.nixvim
						];
					};
				}
				];
			};
			okashitop = nixpkgs.lib.nixosSystem {
				system = "x86_64-linux";
				specialArgs = {inherit inputs outputs;};

				modules = [
					./hosts/okashitop
						catppuccin.nixosModules.catppuccin
						sops-nix.nixosModules.sops
						{
							sops = {
								defaultSopsFile = ./secrets/secrets.yaml;
								age.sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
								secrets = {
									"hosts/okashitop/luksPwd" = {};
									"hosts/okashitop/password" = {};
								};
							};
						}

				home-manager.nixosModules.home-manager
				{
					home-manager.useGlobalPkgs = true;
					home-manager.useUserPackages = true;

					home-manager.extraSpecialArgs = inputs;
					home-manager.users.okashi = {
						imports = [
							./home/default.nix
							./home/gui.nix
							catppuccin.homeManagerModules.catppuccin
              nixvim.homeManagerModules.nixvim
						];
					};
				}
				disko.nixosModules.disko
					];
			};
		};
	};
}

