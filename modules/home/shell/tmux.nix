{
  flake.modules.nixos.shell = {
    programs.tmux = {
      enable = true;
      mouse = true;
      terminal = "tmux-256color";
    };
  };
}
