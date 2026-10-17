return {
    'neovim/nvim-lspconfig',
    dependencies = {
        { 'mason-org/mason.nvim', opts = {} },
        {
            'mason-org/mason-lspconfig.nvim',
            opts = { ensure_installed = { 'lua_ls' }, automatic_enable = { 'lua_ls' } },
        },
        'WhoIsSethDaniel/mason-tool-installer.nvim',
        'hrsh7th/cmp-nvim-lsp',
        { 'j-hui/fidget.nvim', opts = {} },
    },
    config = function()
        local capabilities = require('cmp_nvim_lsp').default_capabilities()
        -- Request plain completion items rather than snippet expansion.
        capabilities.textDocument.completion.completionItem.snippetSupport = false
        vim.lsp.config('*', { capabilities = capabilities })
        vim.lsp.config('lua_ls', {
            settings = {
                Lua = {
                    runtime = { version = 'LuaJIT' },
                    workspace = { library = { '${3rd}/love2d/library' } },
                },
            },
        })
        require('mason-tool-installer').setup({ ensure_installed = { 'stylua' } })

        local group = vim.api.nvim_create_augroup('lsp-attach', { clear = true })
        vim.api.nvim_create_autocmd('LspAttach', {
            group = group,
            callback = function(event)
                local telescope = require('telescope.builtin')
                local mappings = {
                    grr = { telescope.lsp_references, 'References' },
                    gri = { telescope.lsp_implementations, 'Implementation' },
                    grd = { telescope.lsp_definitions, 'Definition' },
                    grD = { vim.lsp.buf.declaration, 'Declaration' },
                    gO = { telescope.lsp_document_symbols, 'Document symbols' },
                    gW = { telescope.lsp_dynamic_workspace_symbols, 'Workspace symbols' },
                    grt = { telescope.lsp_type_definitions, 'Type definition' },
                }
                -- grn (rename) and gra (code action) are Neovim defaults.
                for key, mapping in pairs(mappings) do
                    vim.keymap.set(
                        'n',
                        key,
                        mapping[1],
                        { buffer = event.buf, desc = 'LSP: ' .. mapping[2] }
                    )
                end

                local client = vim.lsp.get_client_by_id(event.data.client_id)
                if
                    not client
                    or not client:supports_method('textDocument/documentHighlight', event.buf)
                then
                    return
                end
                -- One group per buffer avoids duplicate callbacks when multiple servers attach.
                local highlights =
                    vim.api.nvim_create_augroup('lsp-highlight-' .. event.buf, { clear = true })
                vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                    group = highlights,
                    buffer = event.buf,
                    callback = vim.lsp.buf.document_highlight,
                })
                vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
                    group = highlights,
                    buffer = event.buf,
                    callback = vim.lsp.buf.clear_references,
                })
            end,
        })
        vim.api.nvim_create_autocmd('LspDetach', {
            group = group,
            callback = function(event)
                for _, client in ipairs(vim.lsp.get_clients({ bufnr = event.buf })) do
                    if
                        client.id ~= event.data.client_id
                        and client:supports_method('textDocument/documentHighlight', event.buf)
                    then
                        return
                    end
                end
                vim.api.nvim_buf_call(event.buf, vim.lsp.buf.clear_references)
                local highlights = 'lsp-highlight-' .. event.buf
                if vim.fn.exists('#' .. highlights) == 1 then
                    vim.api.nvim_del_augroup_by_name(highlights)
                end
            end,
        })
    end,
}
