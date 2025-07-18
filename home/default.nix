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
    ripgrep-all
    bat
    fd
    mpv
  ];
  fonts.fontconfig.enable = true;
  programs.fzf.enable = true;
  programs.bottom.enable = true;
  programs.eza = {
    enable = true;
    icons = "auto";
    git = true;
  };
  programs.nix-index.enable = true;
  programs.tmux = {
    enable = true;
    mouse = true;
    terminal = "tmux-256color";
  };
  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting
      set --universal pure_enable_single_line_prompt true
      set --universal pure_enable_nixdevshell true
      abbr --add cat bat -pp
    '';
    plugins = with pkgs.fishPlugins; [
      {
        name = "autopair";
        src = autopair.src;
      }
      {
        name = "fzf-fish";
        src = fzf-fish.src;
      }
      {
        name = "colored-man-pages";
        src = colored-man-pages.src;
      }
      {
        name = "pure";
        src = pure.src;
      }
    ];
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
