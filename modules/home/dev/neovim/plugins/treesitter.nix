{
  flake.modules.homeManager.neovim = {
    programs.nixvim.plugins = {
      treesitter.enable = true;
      treesitter-context.enable = true;
    };
  };
}
