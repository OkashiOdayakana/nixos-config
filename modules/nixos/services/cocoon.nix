{
  config,
  inputs,
  pkgs,
  ...
}:
{
  flake.modules.nixos.cocoon =
    { ... }:
    {
      sops.secrets.pds-env = { };
      virtualisation.oci-containers.containers.cocoon = {
        image = "ghcr.io/haileyok/cocoon:latest";
        autoStart = true;
        ports = [
          "8067:8067"
        ];
        environment = {
          COCOON_ADDR = ":8067";
          COCOON_DID = "did:web:cocoon.t4tlabs.net";
          COCOON_HOSTNAME = "cocoon.t4tlabs.net";
          COCOON_ROTATION_KEY_PATH = "/keys/rotation.key";
          COCOON_JWK_PATH = "/keys/jwk.key";
          COCOON_RELAYS = "https://bsky.network";
          COCOON_ADMIN_PASSWORD = "4c3454b0ab6a9966c6fd592051aea1ce";
          COCOON_SESSION_SECRET = "02c33337b4b55371141af0ec198dffc3dc1c464d7e60e846596330802f1dd7b5";
	  COCOON_CONTACT_EMAIL = "isla@t4tlabs.net";
        };
      };
      services.caddy.virtualHosts."cocoon.t4tlabs.net" = {
        serverAliases = [ "*.cocoon.t4tlabs.net" ];
        extraConfig = ''
                            import tls_settings 
                            handle /xrpc/* {
                                reverse_proxy http://localhost:8067
                            }
                            handle /.well-known/atproto-did {
                                reverse_proxy http://localhost:8067
                            }
          handle /xrpc/app.bsky.ageassurance.getState {
          		header content-type "application/json"
          		header access-control-allow-headers "authorization,dpop,atproto-accept-labelers,atproto-proxy"
          		header access-control-allow-origin "*"
          		respond `{"state":{"lastInitiatedAt":"2025-07-14T14:22:43.912Z","status":"assured","access":"full"},"metadata":{"accountCreatedAt":"2022-11-17T00:35:16.391Z"}}` 200
          }
        '';
      };
    };
}
