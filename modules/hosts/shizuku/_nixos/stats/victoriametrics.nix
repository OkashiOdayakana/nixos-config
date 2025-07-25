{ config, ... }:

{
  services.victoriametrics = {
    enable = true;
    prometheusConfig = {
      scrape_configs = [
        {
          job_name = "node";
          static_configs = [
            {
              targets = [
                "localhost:${toString config.services.prometheus.exporters.node.port}"
                "dns.okashi-lan.org:9100"
              ];
            }
          ];
        }
        {
          job_name = "unpoller";
          static_configs = [
            {
              targets = [ "localhost:9130" ];
            }
          ];
        }
        {
          job_name = "nut";
          static_configs = [
            {
              targets = [ "localhost:9199" ];
            }
          ];
        }
      ];
    };
  };
  services.prometheus.exporters = {
    node = {
      enable = true;
      port = 9000;
      # https://github.com/NixOS/nixpkgs/blob/nixos-24.05/nixos/modules/services/monitoring/prometheus/exporters.nix
      enabledCollectors = [ "systemd" ];
      # /nix/store/zgsw0yx18v10xa58psanfabmg95nl2bb-node_exporter-1.8.1/bin/node_exporter  --help
      extraFlags = [
        "--collector.ethtool"
        "--collector.softirqs"
        "--collector.tcpstat"
      ];
    };
    nut.enable = true;
  };
  services.victorialogs.enable = true;
}
