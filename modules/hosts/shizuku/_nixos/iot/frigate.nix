{
  config,
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
          output_args:
            record: preset-record-generic
        onvif:
          host: '10.0.5.5'
          password: ${config.sops.placeholder.cam-pwd}
          port: 80
          user: admin
    detect:
      enabled: False
    detectors:
      ov:
        device: GPU
        type: openvino
    mqtt:
      enabled: False
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
    go2rtc:
      streams:
        Front:
          - ffmpeg:rtsp://admin:${config.sops.placeholder.cam-pwd}@10.0.5.5:554/cam/realmonitor?channel=1&subtype=0#video=copy
        Front_sub:
          - ffmpeg:rtsp://admin:${config.sops.placeholder.cam-pwd}@10.0.5.5:554/cam/realmonitor?channel=1&subtype=1#video=copy
      webrtc:
        candidates:
          - ha.okashi-lan.org:8555
          - cams.okashi-lan.org:8555
          - 10.1.0.5:8555
          - stun:8555
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
      enabled: False
  '';
  sops.secrets."iot/mqtt/frigate" = { };

  virtualisation.oci-containers = {
    backend = "podman";
    containers.frigate = {
      image = "ghcr.io/blakeblackshear/frigate:0.16.0-beta3";
      volumes = [
        "/etc/localtime:/etc/localtime:ro"
        "frigate:/config"
        "${config.sops.templates."frigate-config.yml".path}:/config/config.yml"
        "/Nas-main/frigate:/media/frigate"
      ];
      ports = [
        "8971:8971"
        "8555:8555/tcp"
        "8555:8555/udp"
      ];
      extraOptions = [
        "--device=/dev/dri/renderD128:/dev/dri/renderD128"
        "--shm-size=512mb"
        "--privileged"
      ];
      environment = {
        "NEOReadDebugKeys" = "1";
        "OverrideGpuAddressSpace" = "48";
      };
    };
  };

  services.caddy.reverseProxies."cams.okashi-lan.org".port = 8971;
}
