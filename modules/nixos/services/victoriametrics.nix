{
  flake.modules.nixos.victoriametrics =
    { config, ... }:

    {
      services.victoriametrics = {
        enable = true;
        retentionPeriod = "12"; # no unit, defaults to months

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
    };

}
