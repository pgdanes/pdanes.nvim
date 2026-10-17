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
        'folke/tokyonight.nvim',
        priority = 1000,
        config = function()
            vim.cmd.colorscheme('tokyonight-night')
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
