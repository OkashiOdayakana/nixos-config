{ config, inputs, ... }:
{
  flake.modules = {
    nixos.core.imports = with config.flake.modules.nixos; [
      inputs.disko.nixosModules.disko
      inputs.lix-module.nixosModules.default
      inputs.sops-nix.nixosModules.sops
      inputs.catppuccin.nixosModules.catppuccin
      sops
      home-manager  
    ];
  };
}
