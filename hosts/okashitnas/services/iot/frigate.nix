{
  config,
  lib,
  pkgs,
  ...
}:
{
  sops.secrets = {
    cam-pwd = { };
    mqtt-frigate-pwd = { };
  };
  sops.templates."frigate-config.yml".content = ''
    cameras:
      Front:
        enabled: true
        ffmpeg:
          inputs:
            - input_args: preset-rtsp-restream-low-latency
              path: 'rtsp://[::1]:8554/Front'
              roles:
                - record
            - input_args: preset-rtsp-restream-low-latency
              path: 'rtsp://[::1]:8554/Front_sub'
              roles:
                - detect
                - audio
          output_args:
            record: preset-record-generic-audio-copy
        onvif:
          host: 'fd0a:371b:2c78:5:4836::ca5e'
          password: ${config.sops.placeholder.cam-pwd}
          port: 80
          user: admin
        zones:
          Front-half:
            coordinates: 0.002,0.686,0.393,0.602,1,0.598,0.999,1,0.014,0.997,0,0.995
        motion:
          mask: 0.7,0.027,0.969,0.021,0.97,0.101,0.701,0.099
        objects:
          filters:
            car:
              mask:
                - 0,0.693,0.369,0.542,0.295,0.436,0,0.469
                - 0.625,0.593,1,0.756,1,0.436,0.712,0.483

    detectors:
      ov:
        device: GPU
        type: openvino
    model:
      model_type: yolonas
      width: 320
      height: 320
      input_tensor: nchw
      input_pixel_format: bgr
      path: /config/yolo_nas_m.onnx
      labelmap_path: /labelmap/coco-80.txt
    ffmpeg:
      hwaccel_args: preset-intel-qsv-h264
    objects:
      track:
        - person
        - cat
        - dog
        - car
        - motorcycle
        - bus
        - bicycle
        - horse
    review:
      alerts:
        labels:
          - person
        required_zones: Front-half
      detections:
        labels:
         - car
         - person
         - cat
         - motorcycle
         - bus
        required_zones: Front-half

    go2rtc:
      streams:
        Front:
          - rtsp://admin:${config.sops.placeholder.cam-pwd}@[fd0a:371b:2c78:5:4836::ca5e]:554/cam/realmonitor?channel=1&subtype=0
          - 'ffmpeg:Front#audio=opus'
        Front_sub:
          - rtsp://admin:${config.sops.placeholder.cam-pwd}@[fd0a:371b:2c78:5:4836::ca5e]:554/cam/realmonitor?channel=1&subtype=1
          - 'ffmpeg:Front_sub#audio=opus'
      webrtc:
        candidates:
          - ha.okashi-lan.org:8555
          - cams.okashi-lan.org:8555
          - 10.1.0.5:8555
          - stun:8555
    mqtt:
      enabled: true
      host: localhost
      password: ${config.sops.placeholder.mqtt-frigate-pwd}
      user: frigate
    record:
      enabled: true
      retain:
        days: 4
        mode: all
      alerts:
        retain:
          days: 20
          mode: motion
      detections:
        retain:
          days: 12
          mode: motion
    tls:
      enabled: false
    semantic_search:
      enabled: True
      model_size: large
  '';
  sops.secrets."iot/mqtt/frigate" = { };

  virtualisation.oci-containers = {
    backend = "podman";
    containers.frigate = {
      image = "ghcr.io/blakeblackshear/frigate:latest";
      volumes = [
        "/etc/localtime:/etc/localtime:ro"
        "frigate:/config"
        "${config.sops.templates."frigate-config.yml".path}:/config/config.yml"
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
  services.caddy.virtualHosts."cams.okashi-lan.org" = {
    extraConfig = ''
      import https_header
      encode {
          zstd better
      }
      reverse_proxy http://localhost:8971
    '';
  };
}
