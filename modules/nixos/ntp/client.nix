{
  flake.modules.nixos.ntp-client = {
    services.timesyncd.enable = false;
    services.chrony = {
      enable = true;
      servers = [
        "us.pool.ntp.org"
        "time.nist.gov"
        "time.cloudflare.com"
        "tick.usno.navy.mil"
      ];
    };
  };
}
