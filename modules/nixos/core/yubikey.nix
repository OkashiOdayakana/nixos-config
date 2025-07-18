{
  flake.modules.nixos.core =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        yubikey-manager
        yubikey-personalization
        yubico-piv-tool
        cfssl
        pcsctools
        pcscliteWithPolkit.out
      ];

      hardware.gpgSmartcards.enable = true;
      hardware.ledger.enable = true; # probably unrelated
      services.udev.packages = [ pkgs.yubikey-personalization ];
      services.pcscd.enable = true;

      programs.gnupg.agent = {
        enable = true;
        enableSSHSupport = true;
      };

      systemd.services.shutdownSopsGpg = {
        path = [ pkgs.gnupg ];
        script = ''
          gpgconf --homedir /var/lib/sops --kill gpg-agent
        '';
        wantedBy = [ "multi-user.target" ];
      };
    };
}
