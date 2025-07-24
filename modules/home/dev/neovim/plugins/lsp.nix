{
  flake.modules.homeManager.neovim = {
    programs.nixvim.plugins = {
      lsp.enable = true;
    };
  };
}
