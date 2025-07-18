{
  services.routinator = {
    enable = true;
    settings = {
      rtr-listen = [ "[::]:3323" ];
      http-listen = [ "[::1]:8323" ];
    };
  };

  services.caddy.reverseProxies."rtr.t4tlabs.net".port = 8323;
}
