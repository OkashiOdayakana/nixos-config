{ config, ... }:
{
  sops.secrets.nut-password = { };
  power.ups = {
    enable = true;
    mode = "netserver";
    upsmon = {
      monitor."UPS-HOME" = {
        user = "primary-client";
        powerValue = 1;
      };
    };
    ups."UPS-HOME" = {
      port = "auto";
      driver = "usbhid-ups";
    };
    users = {
      primary-client = {
        passwordFile = config.sops.secrets.nut-password.path;
        upsmon = "primary";
      };
      secondary-client = {
        passwordFile = config.sops.secrets.nut-password.path;
        upsmon = "secondary";
      };
    };
  };
}
