{ ... }:

{
  services.caddy = {
    virtualHosts."ha.okash.it".extraConfig = ''
      reverse_proxy http://localhost:8123
    '';
  };
}
