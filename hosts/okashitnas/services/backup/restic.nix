{ config, lib, ... }:
{
  sops.secrets = {
    restic-b2 = { };
    restic-b2-bucket = { };
    restic-pwd = { };
  };
  services.restic = {
    backups = {
      okashitnas = {
        initialize = true;
        backupPrepareCommand = ''rm -f /tmp/dbdump.sql; /run/current-system/sw/bin/pg_dumpall -U postgres > /tmp/dbdump.sql'';
        backupCleanupCommand = ''rm -f /tmp/dbdump.sql'';
        paths = [
          "/tmp/dbdump.sql"
          "/var/lib/bitwarden_rs"
          "/var/lib/postgresql"
          #"/Nas-main/nextcloud-new"
          #  "/Nas-main/frigate"
          "/Nas-main/immich"
        ];
        extraBackupArgs = [ "--compression=max" ];
        passwordFile = config.sops.secrets.restic-pwd.path;
        environmentFile = config.sops.secrets.restic-b2.path;
        repositoryFile = config.sops.secrets.restic-b2-bucket.path;

        pruneOpts = [
          "--keep-daily 7"
          "--keep-weekly 5"
          "--keep-monthly 12"
        ];

        timerConfig = {
          OnCalendar = "15:30";
          Persistent = true;
          RandomizedDelaySec = "3h";
        };
      };
    };
  };
}
