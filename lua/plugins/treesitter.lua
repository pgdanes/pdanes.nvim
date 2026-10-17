return {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    build = ':TSUpdate',
    config = function()
        -- Match the plugin's queries even for Neovim's bundled languages.
        require('nvim-treesitter').install({
            'c',
            'lua',
            'markdown',
            'markdown_inline',
            'query',
            'vim',
            'vimdoc',
        })
        vim.api.nvim_create_autocmd('FileType', {
            group = vim.api.nvim_create_augroup('treesitter', { clear = true }),
            callback = function(event)
                if vim.bo[event.buf].buftype == '' then
                    -- Fall back to regular syntax when no parser is installed.
                    pcall(vim.treesitter.start, event.buf)
                end
            end,
        })
    end,
}
