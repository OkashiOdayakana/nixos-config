{ ... }:
{
  services.gpsd = {
    enable = true;
    devices = [ "/dev/ttyACM0" ];
    readonly = false;
    extraArgs = [ "-n" ];
  };
  services.chrony = {
    enable = true;
    extraConfig = ''
      pool 2.fedora.pool.ntp.org iburst
      pool pool.ntp.org iburst
      server time1.google.com
      server time2.google.com
      server time3.google.com
      server time4.google.com
      server time.cloudflare.com

      refclock SHM 0 refid NMEA offset 0.00 precision 1e-3 poll 3 noselect
      makestep 1.0 3  
      hwtimestamp *
      allow
      local stratum 1

      leapsectz right/UTC
      # Uncomment the following line to turn logging on.
      log tracking measurements statistics
      logdir /var/log/chrony
    '';
  };
}
