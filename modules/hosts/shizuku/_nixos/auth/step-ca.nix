{ config, ... }:
{
  sops.secrets.ca-idm = {};
  services.step-ca = {
    enable = true;
    address = "127.0.0.1";
    port = 9443;
    settings = builtins.fromJSON (builtins.readFile ./ca.json);
    intermediatePasswordFile = "${config.sops.secrets.ca-idm.path}";
  };
}
