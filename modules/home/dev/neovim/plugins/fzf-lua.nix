{
  flake.modules.homeManager.neovim = {
    programs.nixvim.plugins.fzf-lua.enable = true;
  };
}
