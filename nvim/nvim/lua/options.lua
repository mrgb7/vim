-- Set leader key to space
vim.g.mapleader = ' '

-- Enable mouse support
vim.opt.mouse = 'a'

-- Enable line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Enable cursor line
vim.opt.cursorline = true

-- Enable syntax highlighting
vim.opt.syntax = 'enable'

-- Enable auto-indent
vim.opt.autoindent = true
vim.opt.smartindent = true

-- Set tab width
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- Enable search highlighting
vim.opt.hlsearch = true
vim.opt.incsearch = true

-- Enable case-insensitive search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Enable clipboard
vim.opt.clipboard = 'unnamedplus'

-- Enable filetype detection
vim.opt.filetype = 'on'

-- Enable filetype plugins
vim.opt.filetypeplugin = 'on'

-- Enable filetype indent
vim.opt.filetypeindent = 'on'

-- Enable termguicolors for richer color support
vim.opt.termguicolors = true

-- Enhanced colorscheme setup
vim.g.tokyonight_style = "night" -- Options: night, storm, day
vim.g.tokyonight_transparent = false
vim.g.tokyonight_transparent_sidebar = false
vim.g.tokyonight_italic_comments = true
vim.g.tokyonight_italic_keywords = true
vim.g.tokyonight_italic_functions = true
vim.g.tokyonight_italic_variables = false
vim.g.tokyonight_lualine_bold = true

-- Set colorscheme
vim.cmd('colorscheme tokyonight')

-- Cue language specific settings
vim.api.nvim_create_autocmd("FileType", {
  pattern = "cue",
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.expandtab = true
  end
})

-- File associations for Cue
vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
  pattern = {"*.cue"},
  callback = function()
    vim.cmd("setfiletype cue")
  end
})

-- Git keybindings
vim.api.nvim_set_keymap('n', '<leader>gb', ':Gitsigns toggle_current_line_blame<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>gd', ':Gitsigns diffthis<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>gp', ':Gitsigns preview_hunk<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>gr', ':Gitsigns reset_hunk<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>gs', ':Gitsigns stage_hunk<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>gu', ':Gitsigns undo_stage_hunk<CR>', { noremap = true, silent = true })
