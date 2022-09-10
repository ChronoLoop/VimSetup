local keymap = require('kevin.keymap')
local inoremap = keymap.inoremap
local nnoremap = keymap.nnoremap

nnoremap('<C-p>', ':Telescope find_files<CR>')

nnoremap('<C-S><C-S>', ':set invrelativenumber<CR>')
nnoremap('<C-s>', ':w<CR>')
nnoremap('<C-s>', ':w<CR>')
inoremap('<C-s>', '<Esc>:w<CR>a')

nnoremap('<C-n>', ':NvimTreeToggle<CR>')
nnoremap('<leader>r', ':NvimTreeFindFile<CR>')
nnoremap('<leader>g', ':Git<CR>')

nnoremap('<C-j>', '<C-w>j')
nnoremap('<C-h>', '<C-w>h')
nnoremap('<C-k>', '<C-w>k')
nnoremap('<C-l>', '<C-w>l')
