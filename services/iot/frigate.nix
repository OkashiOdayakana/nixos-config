{
  config,
  lib,
  pkgs,
  ...
}:
let
  test_file = pkgs.writeText "config.yml" ''
    cameras:
      Front:
        enabled: true
        ffmpeg:
          inputs:
            - input_args: preset-rtsp-restream
              path: 'rtsp://127.0.0.1:8554/Front'
              roles:
                - record
            - input_args: preset-rtsp-restream
              path: 'rtsp://127.0.0.1:8554/Front_sub'
              roles:
                - detect
                - audio
          output_args:
            record: preset-record-generic-audio-copy
        onvif:
          host: 192.168.5.20
          password: Brayden123!
          port: 80
          user: admin
    detectors:
      ov:
        device: GPU
        model:
          path: /openvino-model/ssdlite_mobilenet_v2.xml
        type: openvino
    ffmpeg:
      hwaccel_args: preset-vaapi
    go2rtc:
      streams:
        Front:
          - rtsp://admin:Brayden123!@192.168.5.20:554/cam/realmonitor?channel=1&subtype=0
          - 'ffmpeg:Front#audio=opus'
        Front_sub:
          - rtsp://admin:Brayden123!@192.168.5.20:554/cam/realmonitor?channel=1&subtype=1
          - 'ffmpeg:Front_sub#audio=opus'
      webrtc:
        candidates:
          - '192.168.1.5:8555'
          - 'ha.okash.it:8555'
          - 'stun:8555'
    model:
      height: 300
      input_pixel_format: bgr
      input_tensor: nhwc
      labelmap_path: /openvino-model/coco_91cl_bkgr.txt
      width: 300
    mqtt:
      enabled: true
      host: localhost
      password: =g.Djz=6vIsHS/Evsu(Iy;*L
      user: frigate
    record:
      enabled: true
      events:
        retain:
          default: 60
          mode: motion
      retain:
        days: 7
        mode: all
  '';
in
{
  sops.secrets."iot/mqtt/frigate" = { };

  sops.templates.frigate.content = lib.generators.toJSON { } {
    mqtt = {
      enabled = true;
      host = "localhost";
      user = "frigate";
      password = config.sops.placeholder."iot/mqtt/frigate";
    };

    detectors.ov = {
      type = "openvino";
      device = "GPU";
      model.path = "/openvino-model/ssdlite_mobilenet_v2.xml";
    };

    model = {
      width = 300;
      height = 300;
      input_tensor = "nhwc";
      input_pixel_format = "bgr";
      labelmap_path = "/openvino-model/coco_91cl_bkgr.txt";
    };
    #zones = {
    #  Front = {
    #    coordinates = "421,480,588,326,640,246,330,163,0,285,0,480";
    #  };
    #};

    record = {
      enabled = true;
      retain = {
        days = 7;
        mode = "all";
      };
      events = {
        #  required_zones = [ "Front" ];
        retain = {
          default = 60;
          mode = "motion";
        };
      };
    };

    ffmpeg.hwaccel_args = "preset-vaapi";

    go2rtc = {
      streams = {
        Front = [
          ''rtsp://admin:${
            config.sops.placeholder."iot/frigate-cam"
          }@192.168.5.20:554/cam/realmonitor?channel=1&subtype=0''
          "ffmpeg:Front#audio=opus"
        ];
        Front_sub = [
          ''rtsp://admin:${
            config.sops.placeholder."iot/frigate-cam"
          }@192.168.5.20:554/cam/realmonitor?channel=1&subtype=1''
          "ffmpeg:Front_sub#audio=opus"
        ];
      };
      webrtc = {
        candidates = [
          "192.168.1.5:8555"
          "ha.okash.it:8555"
          "stun:8555"
        ];
      };
    };
    cameras.Front = {
      enabled = true;
      onvif = {
        host = "192.168.5.20";
        port = 80;
        user = "admin";
        password = "${config.sops.placeholder."iot/frigate-cam"}";
      };
      ffmpeg = {
        output_args.record = "preset-record-generic-audio-copy";
        inputs = [
          {
            path = ''rtsp://127.0.0.1:8554/Front'';
            input_args = "preset-rtsp-restream";
            roles = [ "record" ];
          }
          {
            path = ''rtsp://127.0.0.1:8554/Front_sub'';
            input_args = "preset-rtsp-restream";
            roles = [
              "detect"
              "audio"
            ];
          }
        ];

      };
    };
  };

  virtualisation.oci-containers = {
    backend = "podman";
    containers.frigate = {
      image = "ghcr.io/blakeblackshear/frigate:stable";
      volumes = [
        "/etc/localtime:/etc/localtime:ro"
        "frigate:/config"
        "${test_file}:/config/config.yml"
        "/Nas-main/frigate:/media/frigate"
      ];
      extraOptions = [
        "--device=/dev/dri/renderD128:/dev/dri/renderD128"
        "--shm-size=512mb"
        "--network=host"
        "--privileged"
      ];
      environment = {
        "NEOReadDebugKeys" = "1";
        "OverrideGpuAddressSpace" = "48";
      };
    };
  };
  services.caddy.virtualHosts."cams.okash.it" = {
    extraConfig = ''
      import https_header
      encode {
          zstd better
      }
      reverse_proxy http://localhost:8971
    '';
  };
}
