-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

require("plugins.lazy");
require("options");
require("keymaps");
require("lsp")
require("treesitter");
require("autocmds");

require("plugins.telescope");
require("plugins.cmp");
