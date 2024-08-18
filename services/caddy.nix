{
  services.caddy = {
    enable = true;
    email = "okashi@okash.it";
    extraConfig = ''
      (https_header) {
          header {
            Strict-Transport-Security "max-age=31536000; includeSubdomains; preload"
            X-XSS-Protection "1; mode=block"
            X-Content-Type-Options "nosniff"
            Referrer-Policy "same-origin"
           -Server
            Permissions-Policy "geolocation=(self) , microphone=()"
          }
      }
    '';
  };
}
