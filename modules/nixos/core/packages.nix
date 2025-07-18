{
  flake.modules.nixos.core =
    { pkgs, lib, ... }:
    {
      environment.systemPackages = with pkgs; [
        git
        curl
        wget
        htop
        lm_sensors
        wireguard-tools
        usbutils
        pciutils
        gnupg
        dig
        openssl
        libgcc
        nixd
        (lib.hiPrio uutils-coreutils-noprefix)
        fastfetch
        tmux
        sbctl
        nvme-cli
        rclone
        vim
        apparmor-profiles
        roddhjav-apparmor-rules
	zellij
      ];
    };
}
