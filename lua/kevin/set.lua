-- ==================================================================================== Initialize
-- ====================================================================================
vim.g.mapleader = ' '

-- Enable provider for only python3 and node
vim.g.python3_host_prog = vim.fn.exepath('python3')
vim.g.loaded_python_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0

-- ====================================================================================
-- Options
-- ====================================================================================

vim.opt.number = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.errorbells = false
vim.opt.smartindent = true
vim.opt.autoindent = true
vim.opt.hidden = true
vim.opt.signcolumn = "yes"
vim.opt.backup = false
vim.opt.updatetime = 300
vim.opt.wrap = false
vim.opt.cursorline = true

-- https://github.com/neovim/neovim/wiki/FAQ#how-to-use-the-windows-clipboard-from-wsl
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

local c = require('onedark.colors')

require('onedark').setup {
    style = 'darker',
    highlights = {
        VertSplit = { bg = c.bg_d }
    }
}
require('onedark').load()
