vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.api.nvim_create_autocmd("BufWritePre", {
  callback = function(ev)
    local dir = vim.fn.fnamemodify(ev.file, ":h")
    if vim.fn.isdirectory(dir) == 0 then
      vim.fn.mkdir(dir, "p")
    end
  end,
})

local opt = vim.opt -- for conciseness

-- line numbers
opt.relativenumber = true -- show relative line numbers
opt.number = true -- shows absolute line number on cursor line

-- tabs & indentation
opt.tabstop = 2 -- 2 spaces for tabs (prettier default)
opt.shiftwidth = 2 -- 2 spaces for indent width
opt.expandtab = true -- expand tab to spaces
opt.autoindent = true -- copy indent from current line when starting new one

-- line wrapping
opt.wrap = false -- disable line wrapping

-- search settings
opt.ignorecase = true -- ignore case when searching
opt.smartcase = true -- if you include mixed case in your search, assume you want case-sensitive

-- cursor line
opt.cursorline = true -- highlight the current cursor line

-- appearance
-- turn on termguicolors for nightfly colorscheme to work
-- (have to use iterm2 or any other true color terminal)
opt.termguicolors = true
opt.background = "dark" -- use light colorscheme variant
opt.signcolumn = "yes" -- show sign column so that text doesn't shift

-- backspace
opt.backspace = "indent,eol,start" -- allow backspace on indent, end of line or insert mode start position

-- clipboard
opt.clipboard:append("unnamedplus") -- use system clipboard as default register

-- split windows
opt.splitright = true -- split vertical window to the right
opt.splitbelow = true -- split horizontal window to the bottom

-- turn off swapfile
opt.swapfile = false

-- Disable Neovim 0.11 default snippet Tab/S-Tab mappings (we use Copilot instead)
vim.g.no_default_snippets_keymaps = 1

-- Enable trailing whitespace highlighting for markdown files
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    -- Create highlight group for trailing whitespace
    vim.cmd([[highlight TrailingWhitespace ctermbg=red guibg=red]])
    
    -- Enable syntax highlighting for trailing whitespace in markdown files
    vim.cmd([[syntax match TrailingWhitespace /\s\+$/ containedin=ALL]])
  end,
})

-- Enable trailing whitespace highlighting for markdown files
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.cmd([[highlight TrailingWhitespace ctermbg=red guibg=red]])
    vim.cmd([[syntax match TrailingWhitespace /\s\+$/ containedin=ALL]])
  end,
})

-- Enable trailing whitespace highlighting for markdown files
vim.cmd([[highlight TrailingWhitespace ctermbg=red guibg=red]])
vim.cmd([[syntax match TrailingWhitespace /\s\+$/ containedin=ALL]])

-- Highlight trailing whitespace in markdown files
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    -- Create highlight group for trailing whitespace
    vim.cmd([[highlight TrailingWhitespace ctermbg=red guibg=red]])
    
    -- Enable syntax highlighting for trailing whitespace in markdown files
    vim.cmd([[syntax match TrailingWhitespace /\s\+$/ containedin=ALL]])
  end,
})

-- Highlight trailing whitespace in markdown files
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.cmd([[highlight TrailingWhitespace ctermbg=red guibg=red]])
    vim.cmd([[syntax match TrailingWhitespace /\s\+$/ containedin=ALL]])
  end,
})
