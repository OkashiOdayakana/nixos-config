{ config, pkgs, ... }:
{
  sops.secrets.ldap-adm-pw = {
    owner = "openldap";
  };
  services.openldap = {
    enable = true;

    # enable plain connections only
    urlList = [
      "ldap:///"
      "ldapi:///"
    ];

    settings = {
      attrs = {
        olcLogLevel = "conns config";
      };

      children = {
        "cn=schema".includes = [
          "${pkgs.openldap}/etc/schema/core.ldif"
          "${pkgs.openldap}/etc/schema/cosine.ldif"
          "${pkgs.openldap}/etc/schema/inetorgperson.ldif"
          "${pkgs.openldap}/etc/schema/nis.ldif"
        ];

        "cn=modules".attrs = {
          objectClass = [ "olcModuleList" ];
          cn = "modules";
          olcModuleLoad = [ "argon2" ];
        };

        "olcDatabase={-1}frontend" = {
          attrs = {
            objectClass = [
              "olcDatabaseConfig"
              "olcFrontendConfig"
            ];
            olcDatabase = "{-1}frontend";
            olcPasswordHash = "{ARGON2}";
            olcAccess = [
              "{0}to * by dn.exact=uidNumber=0+gidNumber=0,cn=peercred,cn=external,cn=auth manage stop by * none stop"
            ];
          };
        };
        "olcDatabase={0}config" = {
          attrs = {
            objectClass = "olcDatabaseConfig";
            olcDatabase = "{0}config";
            olcAccess = [ "{0}to * by * none break" ];
          };
        };
        "olcDatabase={1}mdb" = {
          attrs = {
            objectClass = [
              "olcDatabaseConfig"
              "olcMdbConfig"
            ];
            olcDatabase = "{1}mdb";
            olcDbDirectory = "/var/lib/openldap/data";
            olcDbIndex = [
              "objectClass eq"
              "cn pres,eq"
              "uid pres,eq"
              "sn pres,eq,subany"
            ];
            olcSuffix = "dc=t4tlabs,dc=net";
            olcRootDN = "cn=admin,dc=t4tlabs,dc=net";
            olcRootPW.path = config.sops.secrets.ldap-adm-pw.path;
            olcAccess = [
              ''
                {0}to attrs=userPassword
                  by dn.exact="cn=admin,dc=t4tlabs,dc=net" manage
                  by self write
                  by anonymous auth
                  by * none
              ''

              ''
                {1}to attrs=mail,cn,sn
                  by dn.exact="cn=admin,dc=t4tlabs,dc=net" manage
                  by self write
                  by * read
              ''

              # allow read on anything else
              ''
                {2}to *
                  by dn.exact="cn=admim,dc=t4tlabs,dc=net" manage
                  by * read
              ''

            ];
          };
        };

      };
    };
  };
}
