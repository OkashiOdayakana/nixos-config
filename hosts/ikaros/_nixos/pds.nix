{ config, ... }:
{
  sops.secrets.pds-env = { };
  services.pds = {
    enable = true;
    pdsadmin.enable = true;
    environmentFiles = [ config.sops.secrets.pds-env.path ];
    settings = {
      PDS_HOSTNAME = "okashi.social";
      PDS_INVITE_REQUIRED = "false";
    };
  };
  services.caddy.virtualHosts."okashi.social" = {
    serverAliases = [ "*.okashi.social" ];
    extraConfig = ''
      import tls_settings 
      handle /xrpc/* {
          reverse_proxy http://localhost:3000
      }
      handle /.well-known/atproto-did {
          reverse_proxy http://localhost:3000
      }
    '';
  };
}
