{
  flake.modules.nixos.host_shizuku =
    { pkgs, ... }:
    {
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
