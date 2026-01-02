{
  flake.modules.nixos.meilisearch =
    { config, pkgs, ... }:
    {
      sops.secrets.meilisearch-key = { };

      services.meilisearch = {
        enable = true;
        masterKeyFile = config.sops.secrets.meilisearch-key.path;
      };
    };
}
