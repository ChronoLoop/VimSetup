local packer = require 'packer'

packer.startup(function(use)

    -- Telescope
    use { 'nvim-lua/telescope.nvim', requires = { 'nvim-lua/popup.nvim', 'nvim-lua/plenary.nvim' } }

    -- Core
    use 'wbthomason/packer.nvim'
    use 'preservim/nerdtree'
    use 'tpope/vim-fugitive'
    use 'tpope/vim-surround'
    use 'tpope/vim-commentary'
    use { 'akinsho/nvim-bufferline.lua', requires = 'kyazdani42/nvim-web-devicons' }
    use 'mattn/emmet-vim'
    use 'windwp/nvim-autopairs'
    use 'windwp/nvim-ts-autotag'

    -- LSP
    use 'neovim/nvim-lspconfig'
    use 'creativenull/efmls-configs-nvim'
    use 'jose-elias-alvarez/null-ls.nvim'

    -- Autocompletion and Snippets
    use { 'hrsh7th/vim-vsnip', requires = {
        'hrsh7th/vim-vsnip-integ',
        'rafamadriz/friendly-snippets',
    } }

    use { 'hrsh7th/nvim-cmp', requires = {
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-vsnip',
    } }

    --Theme/Syntax
    use 'ryanoasis/vim-devicons'
    use 'kyazdani42/nvim-web-devicons'
    use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
    use 'tiagofumo/vim-nerdtree-syntax-highlight'
    use 'Yggdroot/indentline'
    use 'navarasu/onedark.nvim'
    use { 'hoob3rt/lualine.nvim', requires = { 'kyazdani42/nvim-web-devicons', opt = true } }
end)
