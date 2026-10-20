return {
    'zaldih/themery.nvim',
    lazy = false,
    dependencies = { 'rebelot/kanagawa.nvim' },
    opts = {
        themes = { 'kanagawa', 'kanagawa-dragon', 'kanagawa-lotus' },
        livePreview = true,
    },
    config = function(_, opts)
        require('themery').setup(opts)
        -- Lowercase command alias, restricted to the whole command line.
        vim.cmd([[cnoreabbrev <expr> theme getcmdtype() == ':' && getcmdline() ==# 'theme' ? 'Themery' : 'theme']])
    end,
}
