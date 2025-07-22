{
  flake.modules.homeManager.neovim = {
    programs.nixvim.lsp.servers.nixd.enable = true;
  };
}
