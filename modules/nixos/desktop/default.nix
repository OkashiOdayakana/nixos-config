{
  flake.modules.nixos.desktop =
    { ... }:
    {
      services.xserver.enable = true;
      programs.dconf.enable = true;
      security.rtkit.enable = true;
      services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        wireplumber.enable = true;

      };

      hardware.bluetooth.enable = true;
      hardware.sensor.iio.enable = true;

      services.dbus.implementation = "broker";

      services.resolved = {
        enable = true;
        dnssec = "allow-downgrade";
        domains = [ "~." ];
        fallbackDns = [
          "1.1.1.1"
          "1.0.0.1"
        ];
        dnsovertls = "opportunistic";
      };

      networking.networkmanager = {
        enable = true;
        dns = "systemd-resolved";
      };

      systemd.services.NetworkManager-wait-online.enable = false;

      users.users.okashi.extraGroups = [ "networkmanager" ];

    };
}
