{
  config,
  lib,
  pkgs,
  ...
}:
with lib;

let
  cfg = config.services.samba;
  samba = cfg.package;
  nssModulesPath = config.system.nssModules.path;
  adDomain = "smb.okashi-lan.org";
  adWorkgroup = "SMB";
  adNetbiosName = "OKASHILAN";
  staticIp = "10.1.0.5";
in
{
  # Disable resolveconf, we're using Samba internal DNS backend
  systemd.services.resolvconf.enable = false;
  environment.etc = {
    resolvconf = {
      text = ''
        search ${adDomain}
        nameserver ${staticIp}
      '';
    };
  };

  # Rebuild Samba with LDAP, MDNS and Domain Controller support
  nixpkgs.overlays = [
    (self: super: {
      samba =
        (super.samba.override {
          enableLDAP = true;
          enableMDNS = true;
          enableDomainController = true;
          enableProfiling = true; # Optional for logging
          # Set pythonpath manually (bellow with overrideAttrs) as it is not set on 22.11 due to bug
        }).overrideAttrs
          (
            finalAttrs: previousAttrs: {
              pythonPath = with super; [
                python3Packages.dnspython
                python3Packages.markdown
                tdb
                ldb
                talloc
              ];
            }
          );
    })
  ];

  # Disable default Samba `smbd` service, we will be using the `samba` server binary
  systemd.services.samba-smbd.enable = false;
  systemd.services.samba = {
    description = "Samba Service Daemon";

    requiredBy = [ "samba.target" ];
    partOf = [ "samba.target" ];

    serviceConfig = {
      ExecStart = "${samba}/sbin/samba --foreground --no-process-group";
      ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
      LimitNOFILE = 16384;
      PIDFile = "/run/samba.pid";
      Type = "notify";
      NotifyAccess = "all"; # may not do anything...
    };
    unitConfig.RequiresMountsFor = "/var/lib/samba";
  };
  services.samba = {
    enable = true;
    enableNmbd = false;
    enableWinbindd = false;
    settings = {
      # Global parameters
      global = {
        "dns forwarder" = "${staticIp}";
        "netbios name" = "${adNetbiosName}";
        realm = "${toUpper adDomain}";
        "server role" = "active directory domain controller";
        workgroup = "${adWorkgroup}";
        "idmap_ldb:use rfc2307" = true;
      };
      sysvol = {
        path = "/var/lib/samba/sysvol";
        "read only" = false;
      };
      netlogon = {
        path = "/var/lib/samba/sysvol/${adDomain}/scripts";
        "read only" = false;
      };
    };
  };
}
