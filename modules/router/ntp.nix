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


      refclock SHM 0 refid NMEA offset 0.0167899 precision 1e-3 poll 3
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
  users.users.chrony.extraGroups = [ "dialout" ];
}
