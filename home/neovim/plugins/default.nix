{
    imports = [
        ./barbar.nix
 #           ./comment.nix
            ./efm.nix
#            ./floaterm.nix
#            ./harpoon.nix
            ./lsp.nix
            ./lualine.nix
            ./markdown-preview.nix
#            ./neorg.nix
            ./neo-tree.nix
#            ./startify.nix
            ./tagbar.nix
            ./telescope.nix
            ./treesitter.nix
#            ./vimtex.nix
    ];

    programs.nixvim = {
        colorschemes.catppuccin = {
            enable = true;
            settings = {
                custom_highlights = ''
                    function(numbercolor)
                    return {
                        CursorLineNr = { fg = numbercolor.peach, style = {} },
                    }
                end
                    '';
                flavour = "mocha"; # "latte", "mocha", "frappe", "macchiato" or raw lua code
            };
        };
        plugins = {
            gitsigns = {
                enable = true;
                settings.signs = {
                    add.text = "+";
                    change.text = "~";
                };
            };

            nvim-autopairs.enable = true;

            nvim-colorizer = {
                enable = true;
                userDefaultOptions.names = false;
            };

            oil.enable = true;

            trim = {
                enable = true;
                settings = {
                    highlight = true;
                    ft_blocklist = [
                        "checkhealth"
                            "floaterm"
                            "lspinfo"
                            "neo-tree"
                            "TelescopePrompt"
                    ];
                };
            };
        };
    };
}
