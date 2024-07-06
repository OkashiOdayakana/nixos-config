return  {
    { "catppuccin/nvim", name = "catppuccin", priority = 1000, opts = {} },
    { "nvim-tree/nvim-web-devicons", opts = {} },
    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        init = function()
            vim.g.lualine_laststatus = vim.o.laststatus
            if vim.fn.argc(-1) > 0 then
                -- set an empty statusline till lualine loads
                vim.o.statusline = " "
            else
                -- hide the statusline on the starter page
                vim.o.laststatus = 0
            end
        end,
        opts = function()
            -- PERF: we don't need this lualine require madness 🤷
            local lualine_require = require("lualine_require")
            lualine_require.require = require

            -- local icons = LazyVim.config.icons

            vim.o.laststatus = vim.g.lualine_laststatus

            local opts = {
                options = {
                    theme = "catppuccin"
                },
                extensions = { "lazy" }
            }

            -- do not add trouble symbols if aerial is enabled
            --[[ if vim.g.trouble_lualine then
                local trouble = require("trouble")
                local symbols = trouble.statusline
                and trouble.statusline({
                    mode = "symbols",
                    groups = {},
                    title = false,
                    filter = { range = true },
                    format = "{kind_icon}{symbol.name:Normal}",
                    hl_group = "lualine_c_normal",
                })
                table.insert(opts.sections.lualine_c, {
                    symbols and symbols.get,
                    cond = symbols and symbols.has,
                })
            end ]]--

            return opts
        end,
    },
    { "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {} }
}
