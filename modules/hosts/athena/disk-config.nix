{ lib, ... }:
{
  flake.modules.nixos.host_athena = {
    disko.devices = {
      disk = {
        main = {
          type = "disk";
          device = lib.mkDefault "/dev/nvme0n1";
          content = {
            type = "gpt";
            partitions = {
              ESP = {
                size = "512M";
                type = "EF00";
                content = {
                  type = "filesystem";
                  format = "vfat";
                  mountpoint = "/boot";
                  mountOptions = [ "defaults" ];
                };
              };
              luks = {
                size = "100%";
                content = {
                  type = "luks";
                  name = "crypted";
                  # disable settings.keyFile if you want to use interactive password entry
                  passwordFile = "/tmp/secret.key";
                  extraOpenArgs = [
                    "--allow-discards"
                    "--perf-no_read_workqueue"
                    "--perf-no_write_workqueue"
                  ];

                  settings = {
                    crypttabExtraOpts = [
                      "fido2-device=auto"
                      "token-timeout=10"
                    ];
                  };

                  content = {
                    type = "btrfs";
                    extraArgs = [ "-f" ];
                    subvolumes = {
                      "/root" = {
                        mountpoint = "/";
                        mountOptions = [
                          "compress=zstd"
                          "ssd"
                          "noatime"
                        ];
                      };
                      "/root-home" = {
                        mountpoint = "/root";
                        mountOptions = [
                          "ssd"
                          "compress=zstd"
                          "noatime"
                          "nodev"
                          "noexec"
                          "nosuid"
                        ];
                      };
                      "/home" = {
                        mountpoint = "/home";
                        mountOptions = [
                          "compress=zstd"
                          "ssd"
                          "noatime"
                          "nosuid"
                          "nodev"
                        ];
                      };
                      "/nix" = {
                        mountpoint = "/nix";
                        mountOptions = [
                          "compress=zstd"
                          "ssd"
                          "noatime"
                        ];
                      };
                      "/log" = {
                        mountpoint = "/var/log";
                        mountOptions = [
                          "compress=zstd"
                          "ssd"
                          "noatime"
                          "noexec"
                          "nosuid"
                          "nodev"
                        ];
                      };
                    };
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
