local packer = require 'packer'

packer.startup(function(use)

    -- Telescope
    use { 'nvim-lua/telescope.nvim', requires = { 'nvim-lua/popup.nvim', 'nvim-lua/plenary.nvim' } }

    -- Core
    use 'wbthomason/packer.nvim'
    use {
        'kyazdani42/nvim-tree.lua',
        requires = {
            'kyazdani42/nvim-web-devicons', -- optional, for file icons
        },
    }
    use 'tpope/vim-fugitive'
    use 'tpope/vim-surround'
    use 'tpope/vim-commentary'
    use { 'akinsho/nvim-bufferline.lua', requires = 'kyazdani42/nvim-web-devicons' }
    use 'mattn/emmet-vim'
    use 'windwp/nvim-autopairs'
    use 'windwp/nvim-ts-autotag'
    use 'airblade/vim-gitgutter'
    use 'jose-elias-alvarez/null-ls.nvim'
    use { "akinsho/toggleterm.nvim", tag = 'v2.*' }

    -- LSP
    use 'neovim/nvim-lspconfig'
    use 'creativenull/efmls-configs-nvim'
    use 'williamboman/nvim-lsp-installer'

    -- Autocompletion
    use { 'hrsh7th/nvim-cmp', requires = {
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-path',
        'saadparwaiz1/cmp_luasnip',
        'hrsh7th/cmp-nvim-lua'
    } }

    -- Snippets
    use 'L3MON4D3/LuaSnip'
    use 'rafamadriz/friendly-snippets'

    --Theme/Syntax
    use 'ryanoasis/vim-devicons'
    use 'kyazdani42/nvim-web-devicons'
    use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
    use 'navarasu/onedark.nvim'
    use { 'hoob3rt/lualine.nvim', requires = { 'kyazdani42/nvim-web-devicons', opt = true } }
    use 'lukas-reineke/indent-blankline.nvim'
    use 'onsails/lspkind.nvim'
end)
