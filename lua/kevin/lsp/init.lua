require 'kevin.lsp.null-ls'
local lspconfig = require 'lspconfig'

-- Global diagnostic config
vim.diagnostic.config({
    underline = { severity_limit = "Error" },
    signs = true,
    update_in_insert = false,
})

-- Add border like lspsaga
vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
    width = 80,
    border = 'single',
})

-- Add border like lspsaga
vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signatureHelp, {
    border = 'single',
})

-- Code action popup
-- but only use it if installed
local success_lsputils, lsputils_codeAction = pcall(require, 'lsputil.codeAction')
if success_lsputils then
    if vim.fn.has('nvim-0.6') == 1 then
        vim.lsp.handlers['textDocument/codeAction'] = lsputils_codeAction.code_action_handler
    else
        vim.lsp.handlers['textDocument/codeAction'] = function(_, _, actions)
            lsputils_codeAction.code_action_handler(nil, actions, nil, nil, nil)
        end
    end
end

local function lsp_map(mode, left_side, right_side, opts)
    opts = opts or { noremap = true }
    vim.api.nvim_buf_set_keymap(vim.api.nvim_get_current_buf(), mode, left_side, right_side, opts)
end

-- if you want to set up formatting on save, you can use this as a callback
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

local lsp_formatting = function(bufnr)
    vim.lsp.buf.format({
        filter = function(client)
            -- disable formatting from tsserver, html, jsonls
            if client.name == 'tsserver'
                or client.name == 'jsonls' or client.name == 'html'
            then
                return false
            end

            if client.name == 'gopls' then
                vim.opt_local.expandtab = false
            end
            return true

        end,
        bufnr = bufnr,
    })
end

local function on_attach(client, bufnr)
    print('Attaching to ' .. client.name)

    if client.supports_method("textDocument/formatting") then
        vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
        vim.api.nvim_create_autocmd("BufWritePre", {
            group = augroup,
            buffer = bufnr,
            callback = function()
                lsp_formatting(bufnr)
            end,
        })
    end

    lsp_map('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>')
    lsp_map('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>')
    lsp_map('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>')
    lsp_map('n', 'gw', '<cmd>lua vim.lsp.buf.document_symbol()<CR>')
    lsp_map('n', 'gW', '<cmd>lua vim.lsp.buf.workspace_symbol()<CR>')
    lsp_map('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>')
    lsp_map('n', 'gy', '<cmd>lua vim.lsp.buf.type_definition()<CR>')
    lsp_map('n', '<leader>le', '<cmd>lua vim.diagnostic.setloclist()<CR>')
    lsp_map('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>')
    lsp_map('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>')
    lsp_map('n', '<leader>p', '', {
        noremap = true,
        callback = function()
            lsp_formatting(bufnr)
        end
    })

    -- Replacement for lspsaga
    lsp_map('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>')
    lsp_map('n', '<leader>sh', '<cmd>lua vim.lsp.buf.signature_help()<CR>')
    lsp_map('n', '<leader>af', '<cmd>lua vim.lsp.buf.code_action()<CR>')
    lsp_map('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>')

    local diag_opts = '{ width = 80, focusable = false, border = "single" }'
    lsp_map(
        'n',
        '<leader>ls',
        string.format('<cmd>lua vim.diagnostic.open_float(%d, %s)<CR>', bufnr, diag_opts)
    )


end

local capabilities = vim.lsp.protocol.make_client_capabilities()

-- Only load cmp lsp capabilities when avaiabled
-- in case you uninstall nvim-cmp
local success_cmp_lsp = pcall(require, 'cmp_nvim_lsp')
if success_cmp_lsp then
    capabilities = require 'cmp_nvim_lsp'.default_capabilities(vim.lsp.protocol.make_client_capabilities())
end

local default_config = {
    on_attach = on_attach,
    capabilities = capabilities,
}

local function config(_config)
    return vim.tbl_deep_extend("force", {
        on_attach = on_attach,
        capabilities = capabilities,
    }, _config or {})
end

local servers = {
    'bashls',
    'cssls',
    'html',
    'dockerls',
    'jsonls',
    'tsserver',
    'sumneko_lua',
    'vimls',
    'yamlls'
}
local lsp_installer = require("nvim-lsp-installer")
lsp_installer.setup {
    ensure_installed = servers
}

for _, server in pairs(servers) do
    local has_custom_config, server_custom_config = pcall(require, 'kevin.lsp.settings.' .. server)
    if has_custom_config then
        lspconfig[server].setup(config(server_custom_config))
    else
        lspconfig[server].setup(default_config)
    end

end

lspconfig.gopls.setup(config(
    {
        cmd = { "gopls", "serve" },
        settings = {
            gopls = {
                staticcheck = true,
            },
        },
    }
))
