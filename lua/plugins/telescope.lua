return {
    'nvim-telescope/telescope.nvim',
    dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-tree/nvim-web-devicons',
        {
            'nvim-telescope/telescope-fzf-native.nvim',
            build = 'make',
            cond = function()
                return vim.fn.executable('make') == 1
            end,
        },
    },
    config = function()
        local telescope = require('telescope')
        local builtin = require('telescope.builtin')
        telescope.setup({
            defaults = { mappings = { i = { ['<C-u>'] = false, ['<C-d>'] = false } } },
        })
        pcall(telescope.load_extension, 'fzf')

        local pickers = {
            ['?'] = { 'oldfiles', '[?] Find recently opened files' },
            ['<space>'] = { 'buffers', '[ ] Find existing buffers' },
            gf = { 'git_files', 'Search [G]it [F]iles' },
            sf = { 'find_files', '[S]earch [F]iles' },
            sh = { 'help_tags', '[S]earch [H]elp' },
            sg = { 'live_grep', '[S]earch by [G]rep' },
            sd = { 'diagnostics', '[S]earch [D]iagnostics' },
            sr = { 'resume', '[S]earch [R]esume' },
        }
        for key, picker in pairs(pickers) do
            vim.keymap.set('n', '<leader>' .. key, builtin[picker[1]], { desc = picker[2] })
        end
        vim.keymap.set('n', '<leader>/', function()
            builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown({
                winblend = 5,
                previewer = false,
            }))
        end, { desc = '[/] Fuzzily search in current buffer' })
    end,
}
