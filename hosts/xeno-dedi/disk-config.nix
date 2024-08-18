{ lib, ... }:
{
  disko.devices = {
    disk = {
      disk1 = {
        type = "disk";
        device = lib.mkDefault "/dev/sda";
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
              };
            };
            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "zroot";
              };
            };
          };
        };
      };
      disk2 = {
        type = "disk";
        device = lib.mkDefault "/dev/sdb";
        content = {
          type = "gpt";
          partitions = {

            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "zroot";
              };
            };
          };
        };
      };
    };
    zpool = {
      zroot = {
        type = "zpool";
        mode = "mirror";
        rootFsOptions = {
          compression = "zstd";
          "com.sun:auto-snapshot" = "false";
        };
        datasets = {
          root = {
            type = "zfs_fs";
            mountpoint = "/";
            options.mountpoint = "legacy";
            postCreateHook = "zfs list -t snapshot -H -o name | grep -E '^zroot/root@blank$' || zfs snapshot zroot/root@blank";
            options."com.sun:auto-snapshot" = "false";
          };
          home = {
            type = "zfs_fs";
            mountpoint = "/home";
            options.mountpoint = "legacy";
          };
          persist = {
            type = "zfs_fs";
            mountpoint = "/persist";
            options.mountpoint = "legacy";
          };
          nix = {
            type = "zfs_fs";
            mountpoint = "/nix";
            options.mountpoint = "legacy";
          };
        };
      };
    };
  };
}
