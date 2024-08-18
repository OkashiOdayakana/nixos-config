{
  config,
  pkgs,
  lib,
  ...
}:
let
  domain = "okashi.me";
  mail-domain = "mail.${domain}";
in
{
  sops.secrets.cf-acme = { };
  security.acme.certs.${mail-domain} = {
    dnsProvider = "cloudflare";
    credentialFiles = {
      "CF_DNS_API_TOKEN_FILE" = config.sops.secrets.cf-acme.path;
    };
    dnsPropagationCheck = true;
  };
  services.nginx.virtualHosts =
    let
      secrets = "/run/credentials/nginx.service";
    in
    {
      ${mail-domain} = {
        forceSSL = true;
        enableACME = false;
        sslCertificate = "${secrets}/cert.pem";
        sslCertificateKey = "${secrets}/key.pem";
        locations."/" = {
          proxyPass = "https://localhost:8443";
        };
      };
    };
  systemd.services.nginx =

    {
      enable = config.services.nginx.enable;

      requires = [ "acme-finished-${mail-domain}.target" ];

      serviceConfig.LoadCredential =
        let
          certDir = config.security.acme.certs.${mail-domain}.directory;
        in
        [
          "cert.pem:${certDir}/cert.pem"
          "key.pem:${certDir}/key.pem"
        ];
    };
  systemd.services.stalwart-mail = {
    enable = config.services.stalwart-mail.enable;

    requires = [ "acme-finished-${mail-domain}.target" ];

    serviceConfig.LoadCredential =
      let
        certDir = config.security.acme.certs.${mail-domain}.directory;
      in
      [
        "cert.pem:${certDir}/cert.pem"
        "key.pem:${certDir}/key.pem"
      ];
  };

  services.stalwart-mail =
    let
      secrets = "/run/credentials/stalwart-mail.service";
    in
    {
      enable = true;
      settings = {

        server.hostname = mail-domain;

        certificate.default = {
          cert = "file://${secrets}/cert.pem";
          private-key = "file://${secrets}/key.pem";
        };

        server.certificate = "default";

        server.tls = {
          enable = true;
          implicit = false;
          timeout = "1m";
          certificate = "default";
          ignore-client-order = true;
        };

        store.db = {
          type = "rocksdb";
          path = "/var/lib/stalwart-mail/db";
          compression = "lz4";
        };
        storage = {
          blob = "db";
          data = "db";
          fts = "db";
          lookup = "db";
        };
      };
    };
}
