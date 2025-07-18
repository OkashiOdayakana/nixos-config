
{
  flake.modules.homeManager.neovim = 
      {config, pkgs,  ...}: {
    programs.neovim = {
      package = pkgs.neovim-unwrapped;
      enable = true;
      defaultEditor = true;
      vimAlias = true;
      plugins = with pkgs.vimPlugins; [
        nvim-treesitter
        nvim-treesitter.withAllGrammars
      ];
      extraPackages = with pkgs; [
        lua-language-server
        efm-langserver
        nixfmt-rfc-style
        golangci-lint
      ];

    };

    home.file.".config/nvim" = {
      recursive = true;
      source = config.lib.file.mkOutOfStoreSymlink "/home/okashi/nixos-config-rewrite/modules/home/dev/editors/neovim/_nvim";
    };
  };
}
