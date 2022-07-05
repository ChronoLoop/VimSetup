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

local function lsp_map(mode, left_side, right_side)
    vim.api.nvim_buf_set_keymap(vim.api.nvim_get_current_buf(), mode, left_side, right_side, { noremap = true })
end

local function on_attach(client, bufnr)
    print('Attaching to ' .. client.name)

    lsp_map('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>')
    lsp_map('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>')
    lsp_map('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>')
    lsp_map('n', 'gw', '<cmd>lua vim.lsp.buf.document_symbol()<CR>')
    lsp_map('n', 'gW', '<cmd>lua vim.lsp.buf.workspace_symbol()<CR>')
    lsp_map('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>')
    lsp_map('n', 'gt', '<cmd>lua vim.lsp.buf.type_definition()<CR>')
    lsp_map('n', '<leader>le', '<cmd>lua vim.diagnostic.setloclist()<CR>')
    lsp_map('n', '<leader>p', '<cmd>lua vim.lsp.buf.formatting()<CR>')

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
    -- disable formatting from tsserver
    if client.name == 'tsserver'
        or client.name == 'jsonls'
    then
        client.resolved_capabilities.document_formatting = false
    end

    if client.name == 'gopls' then
        vim.opt.expandtab = false
        vim.api.nvim_create_autocmd("BufWritePre", {
            pattern = { "*.go" },
            callback = function()
                vim.lsp.buf.formatting_sync()
            end,
        })
    end
end

local capabilities = vim.lsp.protocol.make_client_capabilities()

-- Only load cmp lsp capabilities when avaiabled
-- in case you uninstall nvim-cmp
local success_cmp_lsp = pcall(require, 'cmp_nvim_lsp')
if success_cmp_lsp then
    capabilities = require 'cmp_nvim_lsp'.update_capabilities(vim.lsp.protocol.make_client_capabilities())
end

local default_config = {
    on_attach = on_attach,
    capabilities = capabilities,
}

-- Language Servers
lspconfig.bashls.setup(default_config)
lspconfig.cssls.setup(default_config)
lspconfig.dockerls.setup(default_config)
lspconfig.html.setup(default_config)
lspconfig.jsonls.setup(default_config)
lspconfig.vimls.setup(default_config)
lspconfig.yamlls.setup(default_config)

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
local null_ls = require('null-ls')
local formatting = null_ls.builtins.formatting
null_ls.setup {
    debug = false,
    sources = {
        formatting.prettier,
    },
    on_attach = function(client, bufnr)
        if client.supports_method("textDocument/formatting") then
            vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
            vim.api.nvim_create_autocmd("BufWritePre", {
                group = augroup,
                buffer = bufnr,
                callback = function()
                    -- on 0.8, you should use vim.lsp.buf.format({ bufnr = bufnr }) instead
                    vim.lsp.buf.formatting_sync()
                end,
            })
        end
    end,
}

-- Lua language server
local sumneko_root_path = os.getenv("HOME") .. '/.local/share/lua-language-server'
local sumneko_binary = sumneko_root_path .. '/bin/lua-language-server'

lspconfig.sumneko_lua.setup(vim.tbl_extend('force', default_config, {
    cmd = { sumneko_binary, "-E", sumneko_root_path .. "/main.lua" },
    settings = {
        Lua = {
            runtime = {
                version = 'LuaJIT',
                path = vim.split(package.path, ";"),
            },
            diagnostics = { globals = { 'vim' } },
            workspace = { library = vim.api.nvim_get_runtime_file('', true) },
            telemetry = { enable = false },
        },
    },
}))

local function organize_imports()
    local params = {
        command = "_typescript.organizeImports",
        arguments = { vim.api.nvim_buf_get_name(0) },
        title = ""
    }
    vim.lsp.buf.execute_command(params)
end

lspconfig.tsserver.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    commands = {
        OrganizeImports = {
            organize_imports,
            description = "Organize Imports"
        }
    },
    filetype = { 'typescript', 'typescriptreact', 'typescript.tsx' }
}

lspconfig.gopls.setup(default_config)
