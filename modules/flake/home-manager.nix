/*
  Required to define `homeConfigurations` in multiple files.

  Otherwise:
    The option `flake.homeConfigurations' is defined multiple times while it's expected to be unique.
*/
{
  lib,
  flake-parts-lib,
  inputs,
  ...
}:
{
  imports = [
    inputs.home-manager.flakeModules.home-manager
  ];
  options = {
    flake = flake-parts-lib.mkSubmoduleOptions {
      homeConfigurations = lib.mkOption {
        type = with lib.types; lazyAttrsOf raw;
        default = { };
      };
    };
  };
}
