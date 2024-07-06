return {
    {
        'stevearc/conform.nvim',
        opts = {
            format_on_save = {
                lsp_format = "prefer",
                timeout_ms = 500,
            },
            notify_on_error = true,
        },
    }
}
