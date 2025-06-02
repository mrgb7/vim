-- Enable syntax highlighting
vim.cmd('syntax on')

-- Enable filetype detection and plugin loading
vim.cmd('filetype plugin indent on')

-- Set leader key to space
vim.g.mapleader = ' '

-- Load plugins
require('plugins')

-- Load colorscheme configuration (this also applies the default theme)
require('colorscheme')

-- Available theme commands:
-- :ThemeCatppuccin - Colorful modern theme with pastel colors
-- :ThemeTokyonight - A clean, dark Neovim theme
-- :ThemeNightfox - A dark color scheme based loosely on Nord
-- :ThemeDuskfox - Purple-tinted version of Nightfox
-- :ThemeNordfox - Arctic, north-bluish color theme
-- :ThemeTerafox - A dark, vibrant theme with blue-green tint
-- :ThemeCarbonfox - Desaturated theme for focus

-- Load configurations
require('config')
require('statusline')
require('indent_config')

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