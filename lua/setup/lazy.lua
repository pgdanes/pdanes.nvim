local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system {
        'git',
        'clone',
        '--filter=blob:none',
        'https://github.com/folke/lazy.nvim.git',
        '--branch=stable', -- latest stable release
        lazypath,
    }
end

vim.opt.rtp:prepend(lazypath)
require('lazy').setup({
    -- NOTE: First, some plugins that don't require any configuration
    -- Git related plugins
    'tpope/vim-fugitive',
    'tpope/vim-rhubarb',
    -- Detect tabstop and shiftwidth automatically
    'tpope/vim-sleuth',
    'gpanders/nvim-parinfer',

    -- NOTE: This is where your plugins related to LSP can be installed.
    --  The configuration is done below. Search for lspconfig to find it below.
    {
        -- LSP Configuration & Plugins
        'neovim/nvim-lspconfig',
        dependencies = {
            -- Automatically install LSPs to stdpath for neovim
            { 'williamboman/mason.nvim', config = true },
            'williamboman/mason-lspconfig.nvim',
            'WhoIsSethDaniel/mason-tool-installer.nvim',

            -- Useful status updates for LSP
            -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
            {
                'j-hui/fidget.nvim',
                tag = 'legacy',
                opts = {}
            },
        },
    },

    {
        -- Autocompletion
        'hrsh7th/nvim-cmp',
        dependencies = {
            -- Snippet Engine & its associated nvim-cmp source
            'L3MON4D3/LuaSnip',
            'saadparwaiz1/cmp_luasnip',
            -- Adds LSP completion capabilities
            'hrsh7th/cmp-nvim-lsp',
            -- Adds a number of user-friendly snippets
            'rafamadriz/friendly-snippets',
        },
    },

    {
        'stevearc/oil.nvim',
        opts = {},
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("oil").setup {
                view_options = {
                    show_hidden = true
                }
            }
        end
    },

    -- {
    --     'Exafunction/codeium.vim',
    --     event = 'BufEnter',
    --     config = function()
    --         vim.g.codeium_no_map_tab = true
    --
    --         local set_codeium_keymap = function(mode, keymap, command)
    --             vim.keymap.set(mode, keymap, function()
    --                 return vim.fn['codeium#' .. command]()
    --             end, { expr = true, silent = true })
    --         end
    --
    --         set_codeium_keymap('i', '<D-j>', 'Accept')
    --     end
    -- },

    -- Useful plugin to show you pending keybinds.
    {
        'folke/which-key.nvim',
        opts = {}
    },

    {
        -- Adds git related signs to the gutter, as well as utilities for managing changes
        'lewis6991/gitsigns.nvim',
        opts = {
            -- See `:help gitsigns.txt`
            signs = {
                add = { text = '+' },
                change = { text = '~' },
                delete = { text = '_' },
                topdelete = { text = '‾' },
                changedelete = { text = '~' },
            },
            on_attach = function(bufnr)
                vim.keymap.set('n', '<leader>gp',
                    require('gitsigns').preview_hunk,
                    { buffer = bufnr, desc = 'Preview git hunk' })

                -- don't override the built-in and fugitive keymaps
                local gs = package.loaded.gitsigns

                vim.keymap.set({ 'n', 'v' }, ']c', function()
                        if vim.wo.diff
                        then
                            return ']c'
                        end

                        vim.schedule(function()
                            gs.next_hunk()
                        end)
                        return '<Ignore>'
                    end,
                    {
                        expr = true,
                        buffer = bufnr,
                        desc = "Jump to next hunk"
                    })

                vim.keymap.set({ 'n', 'v' }, '[c', function()
                        if vim.wo.diff then
                            return '[c'
                        end

                        vim.schedule(function()
                            gs.prev_hunk()
                        end)

                        return '<Ignore>'
                    end,
                    {
                        expr = true,
                        buffer = bufnr,
                        desc = "Jump to previous hunk"
                    })
            end,
        },
    },

    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        opts = {},
        config = function()
            vim.cmd("colorscheme tokyonight-night")
        end
    },

    { "bluz71/vim-moonfly-colors", name = "moonfly", lazy = false, priority = 1000 },

    {
        -- Set lualine as statusline
        'nvim-lualine/lualine.nvim',
        opts = {
            options = {
                icons_enabled = false,
                component_separators = '|',
                section_separators = '',
            },
        },
    },

    {
        -- Add indentation guides even on blank lines
        'lukas-reineke/indent-blankline.nvim',
        main = "ibl",
        opts = {},
    },

    {
        -- "gc" to comment visual regions/lines
        'numToStr/Comment.nvim',
        opts = {}
    },

    {
        -- Fuzzy Finder (files, lsp, etc)
        'nvim-telescope/telescope.nvim',
        branch = '0.1.x',
        dependencies = {
            'nvim-lua/plenary.nvim',
            -- Fuzzy Finder Algorithm which requires local dependencies to be built.
            -- Only load if `make` is available. Make sure you have the system
            -- requirements installed.
            {
                'nvim-telescope/telescope-fzf-native.nvim',
                -- NOTE: If you are having trouble with this installation,
                --       refer to the README for telescope-fzf-native for more instructions.
                build = 'make',
                cond = function()
                    return vim.fn.executable 'make' == 1
                end,
            },
            {
                'nvim-tree/nvim-web-devicons',
                config = function()
                    require('nvim-web-devicons').setup()
                end
            }
        },
    },

    {
        -- Highlight, edit, and navigate code
        'nvim-treesitter/nvim-treesitter',
        dependencies = {
            'nvim-treesitter/nvim-treesitter-textobjects',
        },
        build = ':TSUpdate',
    },

    {
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        opts = {},
    },
}, {})
