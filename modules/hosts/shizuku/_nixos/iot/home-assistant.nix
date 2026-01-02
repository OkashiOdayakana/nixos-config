{
  config,
  pkgs,
  ...
}:
let
  home_conf = pkgs.writeText "configuration.yaml" ''
    default_config:
    automation: !include automations.yaml
    script: !include scripts.yaml
    scene: !include scenes.yaml

    frontend:
      themes: !include_dir_merge_named themes
    homeassistant:
      external_url: https://ha.okashi-lan.org
      internal_url: https://ha.okashi-lan.org
      time_zone: America/New_York
    http:
      trusted_proxies:
        - 127.0.0.1
        - ::1
      use_x_forwarded_for: true
      ip_ban_enabled: true
      login_attempts_threshold: 5
      cors_allowed_origins:
        - https://google.com
        - https://www.home-assistant.io
    google_assistant:
      project_id: okashi-ha-22375
      service_account: !include SERVICE_ACCOUNT.JSON
      report_state: true
      exposed_domains:
        - switch
        - light
        - fan
        - camera
    homekit:
      - filter:
          include_domains:
            - light
            - switch
            - fan
  '';
in
{
  sops.secrets."iot/mqtt/zigbee2mqtt.yaml" = {
    owner = "zigbee2mqtt";
    group = "zigbee2mqtt";
  };
  sops.secrets."SERVICE_ACCOUNT.JSON" = {
    sopsFile = ../../../../../secrets/shizuku/SERVICE_ACCOUNT.JSON;
    format = "binary";
  };

  environment.etc."fail2ban/filter.d/home-assistant.conf".text = ''
    [Definition]
    failregex = ^.* \[homeassistant\.components\.http\.ban\] Login attempt or request with invalid authentication from <HOST>.*$

    ignoreregex =

    journalmatch = _SYSTEMD_UNIT=home-assistant.service + _COMM=home-assistant

    datepattern = {^LN-BEG}
  '';

  services.fail2ban.jails = {
    home-assistant = {
      filter = "home-assistant";
      enabled = true;
    };
  };

  virtualisation.oci-containers = {
    backend = "podman";
    containers.homeassistant = {
      volumes = [
        "home-assistant:/config"
        "${home_conf}:/config/configuration.yaml"
        ''${config.sops.secrets."SERVICE_ACCOUNT.JSON".path}:/config/SERVICE_ACCOUNT.JSON''
      ];
      environment.TZ = "America/New_York";
      image = "ghcr.io/home-assistant/home-assistant:stable"; # Warning: if the tag does not change, the image will not be updated
      extraOptions = [ "--network=host" ];
    };
  };

  services.zigbee2mqtt = {
    enable = true;
    settings = {
      homeassistant = {
        enabled = true;
        experimental_event_entities = true;
      };
      discovery_topic = "hass/status";
      legacy_entity_attributes = false;
      legacy_triggers = false;

      #permit_join = true;
      serial = {
        port = "/dev/ttyACM0";
        adapter = "ember";
        baudrate = 230400;
      };
      mqtt = {
        server = "mqtt://localhost:1883";
        user = "zigbee2mqtt";
        password = "!${config.sops.secrets."iot/mqtt/zigbee2mqtt.yaml".path} password";
      };
      frontend.port = 8099;
    };
  };

  services.mosquitto = {
    enable = true;
    listeners = [
      {
        users = {

          homeassistant = {
            acl = [ "readwrite #" ];
            hashedPassword = "$7$101$OxcpDe8CeBBZSFWJ$ov0qlzhUofM0dak8ztwDUq0SB6xBmMCi4odVPS7G4dvOx5U1m0kDoh1/li26h+RqyudAR3t0LCwMvcg/GX7Axw==";
          };

          zigbee2mqtt = {
            acl = [ "readwrite #" ];
            hashedPassword = "$7$101$FtWaHugyRAJMlcCa$EAl3OC8Ux/y6fxfSe2aDjvrxnbkP/l/NmJI0bcrHIltXVCcXyjvsuGmTEhLODm7q76o+ofZ/HJnGJGI2Pyi5MQ==";
          };

          frigate = {
            acl = [ "readwrite #" ];
            hashedPassword = "$7$101$f+AM0D7n8gyVkMHs$BzBvGbqhSqm8BS5oz5VE7EdZtLGQabX1a4lyjVqT87tFmO2WBJ+lqOJEABRZQY4CpxNAMkOoQ3ExvMj5zE4UqA==";
          };

          shelly = {
            acl = [ "readwrite #" ];
            hashedPassword = "$7$101$lcox1J4Weq78DScj$lhy6UN0y84BZtMliyau3ceWzb5wOEw+QX+vMLkYlytDAB3Jub/U50fvALN+xEvT1fGSnZHCL0kCA/Ay0SYmu6Q==";
          };
        };
      }
    ];
  };

  services.caddy.reverseProxies."ha.okashi-lan.org".port = 8123;
  services.caddy.reverseProxies."z2m.okashi-lan.org".port = 8099;
}
