{
  flake.modules.homeManager.neovim = {
    programs.nixvim.plugins.trouble.enable = true;
  };
}
