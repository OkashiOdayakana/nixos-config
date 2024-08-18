{
  services.timesyncd.enable = false;
  services.chrony = {
    enable = true;
    servers = [
      "pool.ntp.org"
      "time.nist.gov"
    ];
  };
}
