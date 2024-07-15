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
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-cosmic = {
      url = "github:lilyinstarlight/nixos-cosmic";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.90.0.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence.url = "github:nix-community/impermanence";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      sops-nix,
      disko,
      catppuccin,
      impermanence,
      lix-module,
      ...
    }@inputs:
    let
      inherit (self) outputs;
    in
    {
      nixosConfigurations = {
        okashitnas = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs outputs;
          };

          modules = [
            ./hosts/okashitnas
            sops-nix.nixosModules.sops
            {
              sops = {
                defaultSopsFile = ./secrets/secrets.yaml;
                age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
                secrets = {
                  "iot/mqtt/frigate" = { };
                  "iot/frigate-cam" = { };
                  "iot/mqtt/zigbee2mqtt.yaml" = { };
                  "vpn/protonvpn/privateKey" = { };
                  "media/transmission/creds.json" = { };
                };
              };
            }

            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;

              home-manager.extraSpecialArgs = inputs;
              home-manager.backupFileExtension = "backup";
              home-manager.users.okashi = {
                imports = [
                  ./home/default.nix
                  catppuccin.homeManagerModules.catppuccin
                ];
              };
            }
          ];
        };
        okashitop = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs outputs;
          };

          modules = [
            ./hosts/okashitop
            catppuccin.nixosModules.catppuccin
            sops-nix.nixosModules.sops
            lix-module.nixosModules.default
            {
              nix.settings = {
                substituters = [ "https://cosmic.cachix.org/" ];
                trusted-public-keys = [ "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE=" ];
              };
              sops = {
                defaultSopsFile = ./secrets/secrets.yaml;
                age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
                secrets = {
                  "hosts/okashitop/luksPwd" = { };
                  "hosts/okashitop/password" = { };
                };
              };
            }

            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;

              home-manager.extraSpecialArgs = inputs;
              home-manager.backupFileExtension = "backup";
              home-manager.users.okashi = {
                imports = [
                  ./home/default.nix
                  ./home/gui.nix
                  catppuccin.homeManagerModules.catppuccin
                ];
              };
            }
            disko.nixosModules.disko
          ];
        };
        Router = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs outputs;
          };

          modules = [
            ./hosts/Router
            sops-nix.nixosModules.sops
            {
              sops = {
                defaultSopsFile = ./secrets/secrets.yaml;
                age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
                secrets = {
                  "hosts/okashitop/password" = { };
                };
              };
            }

            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;

              home-manager.extraSpecialArgs = inputs;

              home-manager.users.okashi = {
                imports = [ ./home/default.nix ];
              };
            }
            disko.nixosModules.disko
            impermanence.nixosModules.impermanence
          ];
        };
      };
    };
}
