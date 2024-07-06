return {
    "neovim/nvim-lspconfig",
    config = function ()
        local capabilities = require('cmp_nvim_lsp').default_capabilities()
        require "lspconfig".gopls.setup {
            capabilities = capabilities,
            settings = {
                gopls = {
                    analyses = {
                        unusedparams = true,
                    },
                    staticcheck = true,
                    gofumpt = true,
                },
            },
        }
        require "lspconfig".nixd.setup {
            capabilities = capabilities,
            cmd = { "nixd" },
            settings = {
                nixd = {
                    nixpkgs = {
                        expr = "import <nixpkgs> { }",
                    },
                    formatting = {
                        command = { "nixfmt" },
                    },
                    options = {
                        nixos = {
                            expr = '(builtins.getFlake ("git+file://" + toString ./.)).nixosConfigurations.okashitop.options',
                        },
                        home_manager = {
                            expr = '(builtins.getFlake ("git+file://" + toString ./.)).homeConfigurations."okashi@okashitop".options',
                        },
                    },
                },
            },
        }
        require "lspconfig".lua_ls.setup {
            capabilities = capabilities,
        }
        require "lspconfig".efm.setup {
            init_options = {documentFormatting = true},
        }
    end
}
