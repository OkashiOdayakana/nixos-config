{
  withSystem,
  inputs,
  lib,
  config,
  ...
}:
let
  inherit (lib) types mkOption;
in
{
  options = {
    nixosHosts =
      let
        nixosHostType = types.submodule {
          options = {
            system = mkOption {
              type = types.str;
              default = "x86_64-linux";
            };
          };
        };
      in
      mkOption {
        type = types.attrsOf nixosHostType;
      };
  };

  config = {
    flake.nixosConfigurations =
      let
        mkHost =
          hostname: options:
          let
            nixpkgs' = inputs.nixpkgs;
          in
          nixpkgs'.lib.nixosSystem {
            inherit (options) system;
            specialArgs.inputs = inputs;
            modules = [
              {
                networking.hostName = "${hostname}";
              }
              config.flake.modules.nixos.core
              (config.flake.modules.nixos."host_${hostname}" or { })
            ];
          };
      in
      lib.mapAttrs mkHost config.nixosHosts;
  };
}
