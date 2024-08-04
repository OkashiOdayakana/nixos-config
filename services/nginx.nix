{ pkgs, ... }:
{
  security.acme = {
    acceptTerms = true;
    defaults.email = "okashi@okash.it";
  };
  services.nginx = {
    enable = true;
    #package = pkgs.nginxQuic;

    recommendedTlsSettings = true;
    recommendedGzipSettings = true;
    recommendedZstdSettings = true;
    recommendedBrotliSettings = true;
    recommendedOptimisation = true;

    # appendHttpConfig = ''
    #   add_header alt-svc 'h3=":443"; ma=86400';
    #   fastcgi_read_timeout 300;
    #    proxy_read_timeout 300;
    # '';
  };
}
