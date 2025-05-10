{ lib, ... }:
{
  disko.devices = {
    disk = {
      vdb = {
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
                settings = {
                  allowDiscards = true;
                };

                content = {
                  type = "btrfs";
                  extraArgs = [ "-f" ];
                  subvolumes = {
                    "/root" = {
                      mountpoint = "/";
                      mountOptions = [
                        "compress-force=zstd:2"
                        "noatime"
                      ];
                    };
                    "/home" = {
                      mountpoint = "/home";
                      mountOptions = [
                        "compress-force=zstd:2"
                        "noatime"
                      ];
                    };
                    "/nix" = {
                      mountpoint = "/nix";
                      mountOptions = [
                        "compress-force=zstd:2"
                        "noatime"
                      ];
                    };
                    "/swap" = {
                      mountpoint = "/.swapvol";
                      swap.swapfile.size = "32G";
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
