{
  services.caddy.virtualHosts."okash.it" = {
    extraConfig = ''
            import tls_settings
            @excl_wellknown {
      	not path /.well-known/*
            }
            root * /var/www/okash.it
            header /.well-known/* Access-Control-Allow-Origin *
            file_server
    '';
  };
  services.caddy.virtualHosts."isla.pet" = {
    extraConfig = ''
      import tls_settings
      root * /var/www/okash.it
      header /.well-known/* Access-Control-Allow-Origin *
      file_server
    '';
  };
  services.caddy.virtualHosts."t4tlabs.net" = {
    extraConfig = ''
            import tls_settings
            header /.well-known/* Access-Control-Allow-Origin *
            header /.well-known/matrix/* Content-Type application/json
            handle /.well-known/webfinger {
      	map {query.resource} {user} {
      		acct:isla@t4tlabs.net isla
      	}
      	rewrite * /.well-known/webfinger/{user}.html
            }
            root /var/www/t4tlabs.net
            file_server
    '';
  };
}
