-- leader must be set before lazy.nvim registers any plugin mappings
vim.g.mapleader = " "
vim.g.maplocalleader = "\\" -- language-specific maps (Go, C) live under <localleader>

require("ragab.core.options")
require("ragab.core.diagnostics")
require("ragab.core.autocmds")
require("ragab.core.keymaps")
