{ config, pkgs, ... }:

{


  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home = {
    username = "okashi";
    homeDirectory = "/home/okashi";
    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    stateVersion = "24.05";
  };


  programs = {
    vim = {
      enable = true;
      plugins = with pkgs.vimPlugins; [ vim-airline ];
      settings = { ignorecase = true; };
      extraConfig = ''
        set mouse=a
      '';
    };
  };


  home.packages = [
    pkgs.nmap
 #   pkgs.gnupg
  ];

 # services.gpg-agent = {
 #       enable = true;
 #       enableSshSupport = true;
 #       enableExtraSocket = true;
 #       defaultCacheTtl = 34560000;
 #       defaultCacheTtlSsh = 34560000;
 #       maxCacheTtl = 34560000;
 #       maxCacheTtlSsh = 34560000;
 #     };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
