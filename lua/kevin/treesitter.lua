require 'nvim-treesitter.configs'.setup {
    ensure_installed = {
        'css',
        'graphql',
        'html',
        'javascript',
        'json',
        'lua',
        'python',
        'tsx',
        'typescript',
        'scss',
        'svelte',
        'go'
    },
    highlight = { enable = true },
    autotag = {
        enable = true,
    },
    autopairs = {
        enable = true,
    },
    indent = {
        enable = true,
        disable = {},
    }
}
