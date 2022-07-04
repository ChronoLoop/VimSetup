local keymap = require('kevin.keymap')

-- Copy to system clipboard (this is for WSL)
keymap.vnoremap('<C-y>', ':w !clip.exe<CR><CR>')
keymap.nmap('<C-p>', ':Telescope find_files<CR>')