{
flake.modules.homeManager.neovim = {
programs.nixvim.plugins = {
conform-nvim = {
enable = true;
settings = {
    formatters_by_ft = {
      nix = [ "nixfmt" ];
    };
    format_on_save = {
        timeout_ms = 500;
    lsp_format = "fallback";
    };  
};
};
lint.enable = true;
};
};
}
