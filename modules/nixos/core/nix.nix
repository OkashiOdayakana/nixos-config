{ inputs, lib, ... }:
{
  flake.modules.nixos.core = {

    nixpkgs.config = {
      allowUnfree = true;
    };

    programs.nh = {
      enable = true;

      clean = {
        enable = true;

        dates = "05:00";
        extraArgs = "--keep 5 --keep-since 8d";
      };
    };

    nix =
      let
        flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
      in
      {
        settings = {
          experimental-features = "nix-command flakes";
          flake-registry = "";

          auto-optimise-store = true;

          # Make legacy nix commands use the XDG base directories instead of creating directories in $HOME.
          use-xdg-base-directories = true;

          # The maximum number of parallel TCP connections used to fetch files from binary caches and by other downloads.
          # It defaults to 25. 0 means no limit.
          http-connections = 128;

          # This option defines the maximum number of substitution jobs that Nix will try to run in
          # parallel. The default is 16. The minimum value one can choose is 1 and lower values will be
          # interpreted as 1.
          max-substitution-jobs = 128;

          # The number of lines of the tail of the log to show if a build fails.
          log-lines = 25;

          # When free disk space in /nix/store drops below min-free during a build, Nix performs a
          # garbage-collection until max-free bytes are available or there is no more garbage.
          # A value of 0 (the default) disables this feature.
          min-free = 128000000; # 128 MB
          max-free = 1000000000; # 1 GB

          trusted-users = [
            "root"
            "@wheel"
          ];

          substituters = [
            "https://nix-community.cachix.org"
            "https://cache.nixos.org"
            "https://nix-cache.t4tlabs.net"
          ];
          trusted-public-keys = [
            "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
            "main:k+C1/dOUOycgd/Kn0gMnsqFyQA/V4x0wXZiwoesZhHo="
          ];

          # Whether to warn about dirty Git/Mercurial trees.
          warn-dirty = false;

          connect-timeout = 5;

          builders-use-substitutes = true;

          # If set to true, Nix will fall back to building from source if a binary substitute
          # fails. This is equivalent to the –fallback flag. The default is false.
          fallback = true;
        };

        # Opinionated: disable channels
        channel.enable = false;

        # Opinionated: make flake registry and nix path match flake inputs
        registry = lib.mapAttrs (_: flake: { inherit flake; }) flakeInputs;
        nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;

      };
  };
}
