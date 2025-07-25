{ inputs, ... }:
{
  perSystem =
    { config, pkgs, ... }:
    {
      packages.TheEssem = pkgs.callPackage ../../pkgs/glitch-soc/default.nix { };
      packages.TheEssem-source = pkgs.callPackage ../../pkgs/glitch-soc/source.nix { };
    };
}
