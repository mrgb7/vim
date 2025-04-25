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

-- Enable termguicolors
vim.opt.termguicolors = true

-- Set colorscheme
vim.cmd('colorscheme tokyonight')

-- Git keybindings
vim.api.nvim_set_keymap('n', '<leader>gb', ':Gitsigns toggle_current_line_blame<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>gd', ':Gitsigns diffthis<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>gp', ':Gitsigns preview_hunk<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>gr', ':Gitsigns reset_hunk<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>gs', ':Gitsigns stage_hunk<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>gu', ':Gitsigns undo_stage_hunk<CR>', { noremap = true, silent = true }) 