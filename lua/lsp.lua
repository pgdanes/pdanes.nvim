-- Configure LSP, runs when LSP attaches to a particular buffer.
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
    callback = function(event)
      local telescope = require('telescope.builtin')
      local map = function(keys, func, desc, mode)
        mode = mode or 'n'
        vim.keymap.set(
          mode,
          keys,
          func, { buffer = event.buf, desc = 'LSP: ' .. desc }
        )
      end

      map('grn', vim.lsp.buf.rename, '[R]e[n]ame')
      map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })
      map('grr', telescope.lsp_references, '[G]oto [R]eferences')
      map('gri', telescope.lsp_implementations, '[G]oto [I]mplementation')
      map('grd', telescope.lsp_definitions, '[G]oto [D]efinition')
      map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
      map('gO', telescope.lsp_document_symbols, 'Open Document Symbols')
      map('gW', telescope.lsp_dynamic_workspace_symbols, 'Open Workspace Symbols')
      map('grt', telescope.lsp_type_definitions, '[G]oto [T]ype Definition')

      -- The following autocommand are used to highlight references of the
      -- word under your cursor when your cursor rests there for a little while.
      --    See `:help CursorHold` for information about when this is executed
      -- When you move your cursor, the highlights will be cleared (the second autocommand).
      local function method_available(method)
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        local buf = event.buf
        return client and client:supports_method(method, buf)
      end
      
      if method_available(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
        local highlight_augroup = vim.api.nvim_create_augroup('lsp-highlight', { clear = false })
        vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
          buffer = event.buf,
          group = highlight_augroup,
          callback = vim.lsp.buf.document_highlight,
        })

        vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
          buffer = event.buf,
          group = highlight_augroup,
          callback = vim.lsp.buf.clear_references,
        })

        vim.api.nvim_create_autocmd('LspDetach', {
          group = vim.api.nvim_create_augroup('lsp-detach', { clear = true }),
          callback = function(event2)
            vim.lsp.buf.clear_references()
            vim.api.nvim_clear_autocmds { group = 'lsp-highlight', buffer = event2.buf }
          end,
        })
      end
    end,
})

-- Enable the following language servers
local servers = {
    ocamllsp = {},
    html = {},
    lua_ls = {
        Lua = {
            log_level = vim.lsp.protocol.MessageType.TRACE,
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
        },
    },
}

local ensure_installed = vim.tbl_keys(servers or {})
vim.list_extend(ensure_installed, { 'stylua', })

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
require('mason-tool-installer').setup { ensure_installed = ensure_installed }
require('mason-lspconfig').setup {
    automatic_enable = true,
    automatic_installation = false,
    ensure_installed = {},
    handlers = {
      function(server_name)
        local server = servers[server_name] or {}

        server.capabilities = vim.tbl_deep_extend(
          'force',
          {},
          capabilities,
          server.capabilities or {}
        )

        require('lspconfig')[server_name].setup(server)
      end,
    },
}

vim.lsp.config['janet-lsp'] = {
  cmd = { 'janet-lsp' },
  filetypes = { 'janet' },
  root_markers = { '.git' },
}
vim.lsp.enable('janet-lsp')
