local g = vim.g     -- Global variables
local opt = vim.opt -- Set options (global/buffer/windows-scoped)

vim.cmd.colorscheme "catppuccin"

--local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
-- buf_set_keymap("n", "<space>f", "<cmd>lua conform.format()<CR>", opts)

-----------------------------------------------------------
-- General
-----------------------------------------------------------
opt.mouse = 'a'                               -- Enable mouse support
opt.clipboard = 'unnamedplus'                 -- Copy/paste to system clipboard
opt.swapfile = false                          -- Don't use swapfile
opt.completeopt = 'menuone,noinsert,noselect' -- Autocomplete options

-----------------------------------------------------------
-- Neovim UI
-----------------------------------------------------------
opt.number = true         -- Show line number
opt.showmatch = true      -- Highlight matching parenthesis
opt.foldmethod = 'marker' -- Enable folding (default 'foldmarker')
opt.colorcolumn = '160'   -- Line lenght marker at 80 columns
opt.splitright = true     -- Vertical split to the right
opt.splitbelow = true     -- Horizontal split to the bottom
opt.ignorecase = true     -- Ignore case letters when search
opt.smartcase = true      -- Ignore lowercase for the whole pattern
opt.linebreak = true      -- Wrap on word boundary
opt.termguicolors = true  -- Enable 24-bit RGB colors
opt.laststatus = 3        -- Set global statusline
opt.signcolumn = 'yes'    -- Reserve space for diagnostic signs
g.mapleader = ","
vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
-----------------------------------------------------------
-- Tabs, indent
-----------------------------------------------------------
opt.expandtab = true   -- Use spaces instead of tabs
opt.shiftwidth = 4     -- Shift 4 spaces when tab
opt.tabstop = 4        -- 1 tab == 4 spaces
opt.smartindent = true -- Autoindent new lines

-----------------------------------------------------------
-- Memory, CPU
-----------------------------------------------------------
opt.hidden = true    -- Enable background buffers
opt.history = 100    -- Remember N lines in history
-- opt.lazyredraw = true       -- Faster scrolling
opt.synmaxcol = 240  -- Max column for syntax highlight
opt.updatetime = 250 -- ms to wait for trigger an event

g.have_nerd_font = true
--vim.api.nvim_set_hl(0, "Normal", { fg = nil, bg = nil })
