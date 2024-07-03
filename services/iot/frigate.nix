{ config, lib, ...}:
{
    sops.secrets."iot/mqtt/frigate" = {};
    sops.templates.frigate.content = lib.generators.toYAML {} {
        mqtt = {
            enabled = true;
            host = "localhost";
            user = "frigate";
            password = config.sops.placeholder."iot/mqtt/frigate";
        };

        detectors.ov = {
            type = "openvino";
            device = "AUTO";
            model.path = "/openvino-model/ssdlite_mobilenet_v2.xml";
        };

        model = {
            width = 300;
            height = 300;
            input_tensor = "nhwc";
            input_pixel_format = "bgr";
            labelmap_path = "/openvino-model/coco_91cl_bkgr.txt";
        };

        zones = {
            Front = {
                coordinates = "421,480,588,326,640,246,330,163,0,285,0,480";
            };
        };

        record = {
            enabled = true;
            retain = {
                days = 7;
                mode = "all";
            };
            events = {
                required_zones = [
                    "Front"
                ];
                retain = {
                    default = 60;
                    mode = "motion";
                };
            };
        };

        ffmpeg.hwaccel_args = "preset-vaapi";

        go2rtc.streams.Front = [
            ''rtsp://admin:${config.sops.placeholder."iot/frigate-cam"}@192.168.5.20:554/cam/realmonitor?channel=1&subtype=0''
                "ffmpeg:Front#audio=opus"
        ];

        cameras.Front = {
            enabled = true;
            ffmpeg = {
                output_args.record = "preset-record-generic-audio-copy";
                inputs = [ {
                    path = ''rtsp://admin:${config.sops.placeholder."iot/frigate-cam"}@192.168.5.20:554/cam/realmonitor?channel=1&subtype=0'';
                    input_args = "preset-rtsp-restream";
                    roles = [
                        "record"
                    ];
                }
                {
                    path = ''rtsp://admin:${config.sops.placeholder."iot/frigate-cam"}@192.168.5.20:554/cam/realmonitor?channel=1&subtype=1'';
                    input_args = "preset-rtsp-restream";
                    roles = [
                        "detect"
                    ];
                } ];

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
                    "${config.sops.templates.frigate.path}:/config/config.yml"
                    "/Nas-main/frigate:/media/frigate"
            ];
            extraOptions = [
                "--device=/dev/dri/renderD128:/dev/dri/renderD128"
                "--shm-size=256mb"
                "--network=host"
                "--privileged"
            ];
        };
    };
}
