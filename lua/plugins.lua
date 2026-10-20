-- Simple plugin specs live here; Lazy also imports lua/plugins/*.lua automatically.
return {
    'tpope/vim-fugitive',
    'tpope/vim-rhubarb',
    'tpope/vim-sleuth',
    { 'folke/lazydev.nvim', ft = 'lua', opts = {} },
    {
        'stevearc/oil.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        opts = { view_options = { show_hidden = true } },
    },
    { 'folke/which-key.nvim', opts = {} },
    {
        'rebelot/kanagawa.nvim',
        priority = 1000,
        opts = {
            colors = { theme = { all = { ui = { bg_gutter = 'none' } } } },
        },
        config = function(_, opts)
            require('kanagawa').setup(opts)
            vim.cmd.colorscheme('kanagawa')
        end,
    },
    {
        'nvim-lualine/lualine.nvim',
        opts = {
            options = { icons_enabled = false, component_separators = '|', section_separators = '' },
        },
    },
    { 'lukas-reineke/indent-blankline.nvim', main = 'ibl', opts = {} },
    { 'numToStr/Comment.nvim', opts = {} },
}
