-- Enable syntax highlighting
vim.cmd('syntax on')

-- Enable filetype detection and plugin loading
vim.cmd('filetype plugin indent on')

-- Set leader key to space
vim.g.mapleader = ' '

-- Load plugins
require('plugins')

-- Load configurations
require('config')

-- Basic settings
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.termguicolors = true
vim.opt.mouse = 'a'
vim.opt.clipboard = 'unnamedplus' 