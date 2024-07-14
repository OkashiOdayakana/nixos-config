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
  programs.ssh.extraConfig = ''
    Host router
      HostName 192.168.1.1
      User okashi
      IdentityAgent /run/user/1000/gnupg/S.gpg-agent.ssh
  '';
}
