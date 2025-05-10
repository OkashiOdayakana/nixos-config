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

  programs.hyfetch.enable = true;

  home.packages = with pkgs; [
    nmap
    ripgrep
    bat
    fd
    zsh-powerlevel10k
    mpv
    fzf
  ];
  programs.tmux = {
    enable = true;
    mouse = true;
    terminal = "tmux-256color";
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      ll = "ls -l";
      update = "sudo nixos-rebuild switch";
    };
    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
    };
    initExtra = ''
      export FZF_BASE=$(fzf-share)
      source "$(fzf-share)/completion.zsh"
      source "$(fzf-share)/key-bindings.zsh"
      source ~/.p10k.zsh
    '';
    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
    ];
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
