{ moduleWithSystem, ... }:
{
  flake.modules.nixos.mastodon = moduleWithSystem (
    perSystem@{ config }:
    nixos@{ config, pkgs, ... }:
    {
      sops.secrets.mstdn-mail = {
        owner = "mastodon";
      };
      sops.secrets.mastodon-fedifetcher.owner = "mastodon";
      services.opensearch.enable = true;
      services.mastodon = {
        enable = true;
        package = perSystem.config.packages.TheEssem;
        localDomain = "puppygirls.forsale";
        streamingProcesses = 3;
        smtp = {
          fromAddress = "noreply@t4tlabs.net";
          passwordFile = config.sops.secrets.mstdn-mail.path;
          user = "noreply@t4tlabs.net";
          port = 587;
          authenticate = true;
          host = "smtp.migadu.com";
        };
        extraConfig = {
          SELF_DESTRUCT = "InB1cHB5Z2lybHMuZm9yc2FsZSI=--59779ffb6ba168e764340684dc2da27b2824b644";
        };
        elasticsearch.host = "127.0.0.1";
      };

      systemd.services.fedifetcher =
        let
          configFormat = pkgs.formats.json { };

          configFile = configFormat.generate "fedifetcher.json" {
            server = "puppygirls.forsale";
            home-timeline-length = 200;
            max-followings = 80;
            max-followers = 80;
            from-notifications = 1;
            lock-hours = 0;
          };
        in
        rec {
          wants = [ "mastodon-web.service" ];
          after = wants;
          serviceConfig = {
            User = config.services.mastodon.user;
            StateDirectory = "fedifetcher";
            WorkingDirectory = "%S/fedifetcher";
          };

          script = ''
            ${pkgs.fedifetcher}/bin/fedifetcher --config "${configFile}" --state-dir "/var/lib/fedifetcher/" --access-token "$(cat ${config.sops.secrets.mastodon-fedifetcher.path})"
          '';
        };

      systemd.timers.fedifetcher = {
        description = "Timer for running fedifetcher";
        wantedBy = [ "timers.target" ];
        timerConfig = {
          Persistent = true;
          OnBootSec = "10min";
          OnUnitActiveSec = "10min";
          Unit = "fedifetcher.service";
        };
        after = [ "network-online.target" ];
        wants = [ "network-online.target" ];
      };

      services.caddy.virtualHosts."puppygirls.forsale".extraConfig = ''
        handle_path /system/* {
            file_server * {
                root /var/lib/mastodon/public-system
            }
        }

        handle /api/v1/streaming/* {
            reverse_proxy  unix//run/mastodon-streaming/streaming.socket
        }

        route * {
            file_server * {
            root ${perSystem.config.packages.TheEssem}/public
            pass_thru
            }
            reverse_proxy * unix//run/mastodon-web/web.socket
        }

        handle_errors {
            root * ${perSystem.config.packages.TheEssem}/public
            rewrite 500.html
            file_server
        }

        encode gzip

        header /* {
            Strict-Transport-Security "max-age=31536000;"
        }
        header /emoji/* Cache-Control "public, max-age=31536000, immutable"
        header /packs/* Cache-Control "public, max-age=31536000, immutable"
        header /system/accounts/avatars/* Cache-Control "public, max-age=31536000, immutable"
        header /system/media_attachments/files/* Cache-Control "public, max-age=31536000, immutable"
      '';

      # Caddy requires file and socket access
      users.users.caddy.extraGroups = [ "mastodon" ];
    }
  );
}
