vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Editor behavior
local opt = vim.opt
opt.hlsearch = false
opt.number = true
opt.mouse = 'a'
opt.clipboard = 'unnamedplus'
opt.breakindent = true
opt.undofile = true
opt.ignorecase = true
opt.smartcase = true
opt.signcolumn = 'yes'
opt.updatetime = 250
opt.timeoutlen = 300
opt.completeopt = 'menuone,noselect'
opt.termguicolors = true
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true

-- Global mappings
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
vim.keymap.set(
    'n',
    '<leader>e',
    vim.diagnostic.open_float,
    { desc = 'Open floating diagnostic message' }
)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })
vim.keymap.set('n', '<leader>E', '<Cmd>Oil<CR>', { silent = true, desc = 'Open file browser' })
vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]])

vim.api.nvim_create_autocmd('TextYankPost', {
    group = vim.api.nvim_create_augroup('YankHighlight', { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})

-- Bootstrap Lazy; import lua/plugins.lua and lua/plugins/*.lua.
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
    local output = vim.fn.system({
        'git',
        'clone',
        '--filter=blob:none',
        '--branch=stable',
        'https://github.com/folke/lazy.nvim.git',
        lazypath,
    })
    assert(vim.v.shell_error == 0, 'Failed to install lazy.nvim:\n' .. output)
end
vim.opt.rtp:prepend(lazypath)
require('lazy').setup('plugins')
