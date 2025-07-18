{ moduleWithSystem, ... }:
{
flake.modules.nixos.mastodon = moduleWithSystem (
  perSystem@{ config }:
    nixos@{ config, ... }:
{
  sops.secrets.mstdn-mail = {
    owner = "mastodon";
  };
  services.opensearch.enable = true;
  services.mastodon = {
    enable = true;
    package = perSystem.config.packages.glitch-soc;
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
    elasticsearch.host = "127.0.0.1";
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
        root ${perSystem.config.packages.glitch-soc}/public
        pass_thru
        }
        reverse_proxy * unix//run/mastodon-web/web.socket
    }

    handle_errors {
        root * ${perSystem.config.packages.glitch-soc}/public
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
