{ inputs, ... }:
{
  perSystem = { config, pkgs, ... }: {
     packages.glitch-soc = pkgs.callPackage ../../pkgs/glitch-soc/default.nix { };
     packages.glitch-soc-source = pkgs.callPackage ../../pkgs/glitch-soc/source.nix { };
  };
}
