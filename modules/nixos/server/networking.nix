{ lib, ... }:
{
  flake.modules.nixos.server = {
    networking.useDHCP = lib.mkForce false;
    systemd.network.enable = true;

    services.resolved = {
      enable = true;
      dnssec = "allow-downgrade";
      domains = [ "~." ];
      dnsovertls = "false";
    };
  };
}
