return
{
    'neovim/nvim-lspconfig',
    dependencies = { 'saghen/blink.cmp' },

    -- example using `opts` for defining servers
    opts = {
        servers = {
            gopls = {
                settings = {
                    gopls = {
                        analyses = {
                            unusedparams = true,
                        },
                        staticcheck = true,
                        gofumpt = true,
                    },
                },

            },
            nixd = {
                cmd = { "nixd" },
                settings = {
                    nixd = {
                        {
                            nixpkgs = {
                                expr = 'import "${flake.inputs.nixpkgs}" { }',
                            },
                            options = {
                                nixos = {
                                    expr =
                                    '(let pkgs = import "${inputs.nixpkgs}" { }; in (pkgs.lib.evalModules { modules =  (import "${inputs.nixpkgs}/nixos/modules/module-list.nix") ++ [ ({...}: { nixpkgs.hostPlatform = builtins.currentSystem;} ) ] ; })).options',
                                },
                                home_manager = {
                                    expr =
                                    '(let pkgs = import "${inputs.nixpkgs}" { }; lib = import "${inputs.home-manager}/modules/lib/stdlib-extended.nix" pkgs.lib; in (lib.evalModules { modules =  (import "${inputs.home-manager}/modules/modules.nix") { inherit lib pkgs; check = false; }; })).options',
                                },
                            },
                        }
                    },
                },
            },
            lua_ls = {}
        }
    },
    config = function(_, opts)
        local lspconfig = require('lspconfig')
        for server, config in pairs(opts.servers) do
            -- passing config.capabilities to blink.cmp merges with the capabilities in your
            -- `opts[server].capabilities, if you've defined it
            config.capabilities = require('blink.cmp').get_lsp_capabilities(config.capabilities)
            lspconfig[server].setup(config)
        end
    end
}
