{
  flake.modules.nixos.host_shizuku =
    { pkgs, ... }:
    {
      fileSystems."/media/seedbox" = {
        device = "[fd7a:115c:a1e0::a001:4c2d]:/media/nfs_share";
        fsType = "nfs";
        options = [
          "nfsvers=4.2"
          "noauto"
          "x-systemd.idle-timeout=600"
          "x-systemd.automount"
        ];
      };
      systemd.services."bcachefs-mount" = {
        after = [ "local-fs.target" ];
        wantedBy = [ "multi-user.target" ];
        script = ''
          #!${pkgs.runtimeShell} -e
          ${pkgs.keyutils}/bin/keyctl link @u @s
          while [ ! -b /dev/sda ]; do
            echo "Waiting for /dev/sda to become available..."
            sleep 5
          done
          if ${pkgs.util-linux}/bin/mountpoint -q /Nas-main ; then
              echo "/Nas-main already mounted, not remounting."
              exit 0
          else
          ${pkgs.bcachefs-tools}/bin/bcachefs mount -f /etc/bcachefs_keyfile /dev/sda:/dev/disk/by-id/nvme-Samsung_SSD_990_PRO_2TB_S73WNU0XA30502H_1 /Nas-main
          fi
        '';
        serviceConfig = {
          Type = "oneshot";
          User = "root";
        };
      };
    };
}
