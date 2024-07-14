local slow_format_filetypes = {}
return {
    {
        'stevearc/conform.nvim',
        opts = {

            format_on_save = function(bufnr)
                if slow_format_filetypes[vim.bo[bufnr].filetype] then
                    return
                end
                local function on_format(err)
                    if err and err:match("timeout$") then
                        slow_format_filetypes[vim.bo[bufnr].filetype] = true
                    end
                end

                return { timeout_ms = 200, lsp_format = "fallback" }, on_format
            end,

            format_after_save = function(bufnr)
                if not slow_format_filetypes[vim.bo[bufnr].filetype] then
                    return
                end
                return { lsp_format = "fallback" }
            end,

            notify_on_error = true,
        },
    },
    {
        "mfussenegger/nvim-lint",
        lazy = true,
        event = { "BufReadPre", "BufNewFile" }, -- to disable, comment this out
        config = function()
            local lint = require("lint")

            lint.linters_by_ft = {
                go = { "golangcilint" },
            }

            local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

            vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
                group = lint_augroup,
                callback = function()
                    lint.try_lint()
                end,
            })

            vim.keymap.set("n", "<leader>li", function()
                lint.try_lint()
            end, { desc = "Trigger linting for current file" })
        end,
    }
}
