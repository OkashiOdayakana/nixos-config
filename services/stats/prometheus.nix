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
          { targets = [ "127.0.0.1:${toString config.services.prometheus.exporters.node.port}" ]; }
        ];
      }
      {
        job_name = "Router";
        static_configs = [
          {
            targets = [
              "192.168.1.1:9002"
              "192.168.1.1:4000"
            ];
          }
        ];
      }
    ];

  };
}
