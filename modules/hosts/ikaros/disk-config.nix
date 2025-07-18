{
  flake.modules.nixos.host_ikaros = {
    disko.devices = {
      disk = {
        nvme0 = {
          type = "disk";
          device = "/dev/sda";
          content = {
            type = "gpt";
            partitions = {
              ESP = {
                type = "EF00";
                size = "1024M";
                name = "boot";
                content = {
                  type = "filesystem";
                  format = "vfat";
                  mountpoint = "/boot";
                  mountOptions = [
                    "umask=0022"
                    "iocharset=utf8"
                    "rw"
                  ];
                };
              };
              empty = {
                # in order for btrfs raid to work we need to do this
                size = "100%";
              };
            };
          };
        };
        nvme1 = {
          type = "disk";
          device = "/dev/sdb";
          content = {
            type = "gpt";
            partitions = {
              root = {
                size = "100%";
                content = {
                  type = "btrfs";
                  extraArgs = [
                    "-f"
                    "-m raid1"
                    "-d single"
                    "/dev/sda2" # needs to be partition 2 of 1st disk and needs to be 2nd disk
                  ];
                  mountpoint = "/";
                  mountOptions = [
                    "rw"
                    "autodefrag"
                    "compress=zstd:force"
                    "noatime"
                  ];
                };
              };
            };
          };
        };
      };
    };
  };
}
