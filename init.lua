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
