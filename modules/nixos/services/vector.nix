{
  flake.modules.nixos.vector =
    { config, pkgs, ... }:
    {
      services.prometheus.exporters = {
        node = {
          enable = true;
          #listenAddress = "127.0.0.1";
        };
        systemd = {
          enable = true;
          #listenAddress = "127.0.0.1";
        };
      };

      environment.systemPackages = with pkgs; [
        vector
      ];

      services.vector = {
        enable = true;
        journaldAccess = true;
        settings = {
          api = {
            enabled = true;
          };
          sources = {
            metrics_local_prometheus = {
              type = "prometheus_scrape";
              endpoints = [
                "http://localhost:9100/metrics" # node exporter
                "http://localhost:9558/metrics" # systemd exporter
              ];
              # This is what I think I want, but it's gonna be localhost all the time...
              instance_tag = "instance";
              endpoint_tag = "endpoint";
              # i want to override a tag with mine.
            };
            # I should turn this one off, in favor of the node exporter metrics
            #        metrics_host_metrics = {
            #          type = "host_metrics";
            #        };
            log_journald = {
              type = "journald";
            };
          };
          # I think this will transform the instance to be the hostname
          transforms = {
            named_prometheus_metrics = {
              type = "remap";
              inputs = [ "metrics_local_prometheus" ];
              source = ''
                .tags.job = "vector"
                .tags.instance = "${config.networking.hostName}"
              '';
            };
          };

          sinks = {
            victoria_metrics = {
              type = "prometheus_remote_write";
              inputs = [
                "named_prometheus_metrics"
              ];
              endpoint = "http://${config.nixosHosts.shizuku.tailscale-ip6}:8428/api/v1/write";
              healthcheck = {
                enabled = false;
              };
            };
            victori_logs = {
              type = "elasticsearch";
              inputs = [
                "log_*"
              ];
              endpoint = "http://${config.nixosHosts.shizuku.tailscale-ip6}:9428/";
            };
          };
        };
      };
    };

}
