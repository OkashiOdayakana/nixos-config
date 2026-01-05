{ ... }:
{
  flake.modules.nixos.sharkey =
    { config, pkgs, ... }:
    let
      newSharkey = pkgs.sharkey.overrideAttrs (
        finalAttrs: prevAttrs: {
          version = "2025.10.5-1";
          src = pkgs.fetchFromGitLab {
            domain = "activitypub.software";
            owner = "TransFem-org";
            repo = "Sharkey";
            tag = "2025.10.2";
            hash = "sha256-JBcWcvhShsZMeilb40163N9eKl25FUBee//q/HNbVZA=";
            fetchSubmodules = true;
          };

          pnpmDeps = pkgs.pnpm_9.fetchDeps {
            inherit (finalAttrs) pname src;
            version = "2025.10.2";
            fetcherVersion = 2;
            hash = "sha256-vFa4To+LWG8E0KrD8A/7l0gbZ8DrNCT+b/nCXIZ80/4=";
          };
        }
      );
    in
    {
      sops.secrets.sharkey-env = { };
      #services.opensearch.enable = true;
      systemd.services.sharkey.path = [ pkgs.ffmpeg ];
      services.postgresql.package = pkgs.postgresql_17;
      services.sharkey = {
        enable = true;
        setupMeilisearch = true;

        settings = {
          url = "https://puppygirls.forsale";
          port = 3001;
          meilisearch.index = "puppygirls_forsale";
        };

        environmentFiles = [ config.sops.secrets.sharkey-env.path ];
      };

      services.caddy.reverseProxies."puppygirls.forsale".port = 3001;
    };
}
