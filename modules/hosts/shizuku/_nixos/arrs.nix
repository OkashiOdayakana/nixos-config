{
  services = {
    sonarr = {
      enable = true;
    };
    caddy.reverseProxies."sonarr.okashi-lan.org".port = 8989;
  };
  users.users."sonarr".extraGroups = [ "media" ];
}
