vim.opt.number = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.errorbells = false
vim.opt.smartindent = true
vim.opt.autoindent = true
vim.opt.hidden = true
vim.opt.signcolumn = "yes"
vim.opt.showmode = false
vim.opt.swapfile = false
vim.opt.backup = false

vim.opt.clipboard = 'unnamedplus'
vim.opt.mouse = 'a'

vim.opt.list = true

vim.opt.tabstop = 4
vim.opt.smarttab = true
vim.opt.expandtab = true
vim.opt.showtabline = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4

-- Don't pass messages to |ins-completion-menu|.
vim.opt.shortmess:append("c")

-- ====================================================================================
-- Theme
-- ====================================================================================

vim.opt.termguicolors = true
vim.opt.relativenumber = true

-- Safely call command to set colorscheme
-- but do not stop execution
local colorscheme_cmd = 'colorscheme onedark'
local success, err = pcall(vim.cmd, colorscheme_cmd)
if not success then
    vim.api.nvim_err_writeln(err)
end
