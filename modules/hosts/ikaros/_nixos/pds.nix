{
  config,
  inputs,
  pkgs,
  ...
}:
{
  sops.secrets.pds-env = { };
  services.bluesky-pds = {
    enable = true;
    pdsadmin.enable = true;
    environmentFiles = [ config.sops.secrets.pds-env.path ];
    settings = {
      PDS_HOSTNAME = "pds.t4tlabs.net";
      PDS_INVITE_REQUIRED = "true";
      PDS_CONTACT_EMAIL_ADDRESS = "isla@t4tlabs.net";
    };
  };
  services.caddy.virtualHosts."pds.t4tlabs.net" = {
    serverAliases = [ "*.pds.t4tlabs.net" ];
    extraConfig = ''
                        import tls_settings 
                        handle /xrpc/* {
                            reverse_proxy http://localhost:3000
                        }
                        handle /.well-known/atproto-did {
                            reverse_proxy http://localhost:3000
                        }
      handle /xrpc/app.bsky.ageassurance.getState {
      		header content-type "application/json"
      		header access-control-allow-headers "authorization,dpop,atproto-accept-labelers,atproto-proxy"
      		header access-control-allow-origin "*"
      		respond `{"state":{"lastInitiatedAt":"2025-07-14T14:22:43.912Z","status":"assured","access":"full"},"metadata":{"accountCreatedAt":"2022-11-17T00:35:16.391Z"}}` 200
      }
    '';
  };
}
