{ ... }:

{
  imports = [
    ./auth
    ./backup
    ./iot
    ./media-nas
    ./stats

    ./cloudflared.nix
    ./nix-serve.nix
    ./caddy.nix
  ];

  # Disable X11.
  services.xserver.enable = false;

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
  };

  services.tailscale.enable = true;
}
