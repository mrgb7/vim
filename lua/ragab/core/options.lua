local opt = vim.opt

-- default file explorer is replaced by nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Mason-installed tools (LSPs, formatters, linters, debuggers) are visible to
-- everything (conform, nvim-lint, go.nvim, terminals) before mason.nvim loads.
local mason_bin = require("ragab.util").mason_bin
if not vim.env.PATH:find(mason_bin, 1, true) then
  vim.env.PATH = mason_bin .. ":" .. vim.env.PATH
end

-- line numbers
opt.number = true
opt.relativenumber = true

-- indentation (per-language overrides live in lua/ragab/langs; .editorconfig wins over both)
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.smartindent = true
opt.shiftround = true

-- long lines: soft-wrap at word boundaries, keep wrapped part indented (toggle: <leader>uw)
opt.wrap = true
opt.linebreak = true
opt.breakindent = true
opt.breakindentopt = "shift:2,sbr"
opt.showbreak = "↪ "
opt.smoothscroll = true
opt.sidescrolloff = 8
opt.scrolloff = 8

-- search
opt.ignorecase = true
opt.smartcase = true
opt.inccommand = "split" -- live preview of :s
opt.grepprg = "rg --vimgrep --smart-case --hidden --glob=!.git/"
opt.grepformat = "%f:%l:%c:%m"

-- appearance
opt.termguicolors = true
opt.background = "light" -- catppuccin latte; <leader>ub switches to mocha
opt.signcolumn = "yes"
opt.cursorline = true
opt.showmode = false -- lualine shows the mode
opt.laststatus = 3 -- one global statusline
opt.pumheight = 12
opt.list = true
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣", extends = "›", precedes = "‹" }
opt.fillchars = { eob = " ", fold = " ", foldopen = "▾", foldclose = "▸", foldsep = " " }

-- folding: treesitter based, everything open by default
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.foldtext = ""
opt.foldlevel = 99
opt.foldlevelstart = 99

-- editing
opt.clipboard = "unnamedplus" -- yank/paste through the system clipboard
opt.mouse = "a"
opt.virtualedit = "block"
opt.confirm = true -- ask instead of failing on :q with unsaved changes

-- windows
opt.splitright = true
opt.splitbelow = true
opt.splitkeep = "screen"

-- files: no swap, persistent undo
opt.swapfile = false
opt.undofile = true
opt.undolevels = 10000

-- responsiveness
opt.updatetime = 250
opt.timeoutlen = 400

-- completion / sessions
opt.completeopt = "menu,menuone,noselect"
opt.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
