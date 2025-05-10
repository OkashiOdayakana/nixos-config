{ config, ... }:
{
  services.prometheus = {
    enable = true;
    port = 9001;
    exporters = {
      node = {
        enable = true;
        enabledCollectors = [ "systemd" ];
        port = 9002;
      };
    };
    scrapeConfigs = [
      {
        job_name = "okashitnas";
        static_configs = [
          { targets = [ "localhost:${toString config.services.prometheus.exporters.node.port}" ]; }
        ];
      }
      {
        job_name = "Router";
        static_configs = [
          {
            targets = [
              "[fd0a:371b:2c78:1::1]:9002"
              "[fd0a:371b:2c78:1::1]:4000"
            ];
          }
        ];
      }
    ];

  };
}
