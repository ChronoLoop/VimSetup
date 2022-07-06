local cmp = require 'cmp'
local lspkind = require 'lspkind'

-- vsnip
vim.g.vsnip_filetypes = {
    javascriptreact = { 'javascript' },
    typescriptreact = { 'typescript' },
}

-- Setup nvim-cmp
cmp.setup {
    snippet = {
        expand = function(args)
            vim.fn['vsnip#anonymous'](args.body)
        end,
    },

    mapping = {
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<CR>'] = cmp.mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Replace }),
        ['<Tab>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i' }),
        ['<S-Tab>'] = cmp.mapping(cmp.mapping.select_prev_item(), { 'i' }),
    },

    -- You should specify your *installed* sources.
    sources = {
        { name = 'nvim_lsp' },
        { name = 'vsnip' },
    },

    formatting = {
        format = lspkind.cmp_format({
            mode = 'symbol_text', -- show only symbol annotations
            maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
            before = function(entry, item)
                item.menu = ({
                    nvim_lsp = '[lsp]',
                    vsnip = '[vsnip]',
                })[entry.source.name]

                return item
            end,
        })


    },
}
