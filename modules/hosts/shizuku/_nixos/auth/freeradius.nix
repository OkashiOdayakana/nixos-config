{
  config,
  pkgs,
  lib,
  ...
}:
let
  pkg = pkgs.freeradius;
  configText = ''
    prefix = /dev/null

    checkrad = ${pkg}/bin/checkrad
    localstatedir = "/var/lib/freeradius"
    sbindir = "${pkg}/sbin"
    logdir = "/var/log/freeradius"
    run_dir = "/run/radiusd"
    libdir = "${pkg}/lib"
    radacctdir = "''${logdir}/radacct"
    pidfile = "/dev/null/var/run/radiusd/radiusd.pid"

    # … log, client, thread pool, module, policy, and server config…
  '';
in
{
  services.freeradius = {
    enable = true;
    configDir = pkgs.writeTextDir "radiusd.conf" configText;
  };
}
