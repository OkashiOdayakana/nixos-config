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

    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.93.0.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence.url = "github:nix-community/impermanence";

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2";

      # Optional but recommended to limit the size of your system closure.
      inputs.nixpkgs.follows = "nixpkgs";
    };
    auto-cpufreq = {
      url = "github:AdnanHodzic/auto-cpufreq";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
      lanzaboote,
      auto-cpufreq,
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
            rootPath = ./.;
          };

          modules = [
            ./hosts/okashitnas
            lix-module.nixosModules.default
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
                  "SERVICE_ACCOUNT.JSON" = {
                    sopsFile = ./secrets/SERVICE_ACCOUNT.JSON;
                    format = "binary";
                  };
                  okashi-pwd = {
                    sopsFile = ./secrets/okashi-pwd;
                    format = "binary";
                  };
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
            disko.nixosModules.disko
            lanzaboote.nixosModules.lanzaboote
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
            #lix-module.nixosModules.default
            auto-cpufreq.nixosModules.default

            {
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
                  catppuccin.homeModules.catppuccin
                ];
              };
            }
            disko.nixosModules.disko
            lanzaboote.nixosModules.lanzaboote
            lix-module.nixosModules.default
          ];
        };
      };
    };
}
