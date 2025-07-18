{
  flake.modules.nixos.attic =
    {
      config,
      inputs,
      pkgs,
      ...
    }:
    {
      sops.secrets = {
        attic-env = {
          sopsFile = ../../../secrets/ikaros/attic.yaml;
        };
        attic-token = {
          sopsFile = ../../../secrets/ikaros/attic.yaml;
        };
      };

      #imports = [ inputs.attic.nixosModules.atticd ];

      environment.systemPackages = with pkgs; [ attic-client ];

      services.atticd = {
        enable = true;

        # Replace with absolute path to your environment file
        environmentFile = config.sops.secrets.attic-env.path;

        settings = {
          listen = "[::1]:8038";
          allowed-hosts = [ "nix-cache.t4tlabs.net" ];
          api-endpoint = "https://nix-cache.t4tlabs.net/";
          database.url = "postgresql://atticd?host=/run/postgresql";

          jwt = { };

          chunking = {
            nar-size-threshold = 64 * 1024; # 64 KiB
            min-size = 16 * 1024; # 16 KiB
            avg-size = 64 * 1024; # 64 KiB
            max-size = 256 * 1024; # 256 KiB
          };
          garbage-collection = {
            interval = "1 week";
            default-retention-period = "3 months";
          };

        };
      };

      services.postgresql = {
        ensureUsers = [
          {
            name = "atticd";
            ensureDBOwnership = true;
          }
        ];
        ensureDatabases = [ "atticd" ];
      };

      systemd.services.attic-watch-store = {
        wantedBy = [ "multi-user.target" ];
        after = [ "network-online.target" ];
        environment.HOME = "/var/lib/attic-watch-store";
        serviceConfig = {
          DynamicUser = true;
          MemoryHigh = "5%";
          MemoryMax = "10%";
          LoadCredential = "prod-auth-token:${config.sops.secrets.attic-token.path}";
          StateDirectory = "attic-watch-store";
        };
        path = [ pkgs.attic-client ];
        script = ''
          set -eux -o pipefail
          ATTIC_TOKEN=$(< $CREDENTIALS_DIRECTORY/prod-auth-token)
          attic login local http://localhost:8038 $ATTIC_TOKEN
          attic use main
          exec attic watch-store local:main
        '';
      };

      services.caddy.reverseProxies."nix-cache.t4tlabs.net".port = 8038;
    };
}
