-- Plugin-independent keymaps. Plugin keymaps are declared in their lazy specs
-- (lua/ragab/plugins), LSP keymaps in lua/ragab/lsp.lua.
local util = require("ragab.util")
local map = util.map

-- editing
map("i", "jk", "<Esc>", "Exit insert mode")
map("n", "<Esc>", "<cmd>nohlsearch<cr><Esc>", "Clear search highlight")
map({ "n", "i", "x" }, "<C-s>", "<cmd>w<cr><Esc>", "Save file")
map("n", "<leader>+", "<C-a>", "Increment number")
map("n", "<leader>-", "<C-x>", "Decrement number")
map("x", "<", "<gv", "Indent left")
map("x", ">", ">gv", "Indent right")
map("x", "J", ":m '>+1<cr>gv=gv", "Move selection down")
map("x", "K", ":m '<-2<cr>gv=gv", "Move selection up")
map("x", "<leader>p", [["_dP]], "Paste without yanking")

-- movement: screen lines through wrapped text (5j still jumps real lines); centred scrolling
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true })
map("n", "<C-d>", "<C-d>zz", "Half page down")
map("n", "<C-u>", "<C-u>zz", "Half page up")
map("n", "n", "nzzzv", "Next search result")
map("n", "N", "Nzzzv", "Prev search result")

-- windows (<C-h/j/k/l> navigation comes from vim-tmux-navigator)
map("n", "<leader>sv", "<C-w>v", "Split vertically")
map("n", "<leader>sh", "<C-w>s", "Split horizontally")
map("n", "<leader>se", "<C-w>=", "Equalize splits")
map("n", "<leader>sx", "<cmd>close<cr>", "Close split")
map("n", "<leader>sm", function()
  -- zoom: open the window in its own tab, toggle back by closing that tab
  if vim.t.zoomed then
    vim.cmd.tabclose()
  else
    vim.cmd("tab split")
    vim.t.zoomed = true
  end
end, "Maximize / restore split")
map("n", "<C-Up>", "<cmd>resize +2<cr>", "Increase height")
map("n", "<C-Down>", "<cmd>resize -2<cr>", "Decrease height")
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", "Decrease width")
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", "Increase width")

-- tabs (<leader>tt/tv/ts/tl are terminal maps, see plugins/terminal.lua)
map("n", "<leader>to", "<cmd>tabnew<cr>", "New tab")
map("n", "<leader>tx", "<cmd>tabclose<cr>", "Close tab")
map("n", "<leader>tn", "<cmd>tabnext<cr>", "Next tab")
map("n", "<leader>tp", "<cmd>tabprevious<cr>", "Prev tab")
map("n", "<leader>tf", "<cmd>tabnew %<cr>", "Open buffer in new tab")

-- buffers
map("n", "<S-h>", "<cmd>bprevious<cr>", "Prev buffer")
map("n", "<S-l>", "<cmd>bnext<cr>", "Next buffer")
map("n", "<leader>bd", "<cmd>bdelete<cr>", "Delete buffer")

-- quickfix (:make, :grep, compiler output)
map("n", "]q", "<cmd>cnext<cr>zz", "Next quickfix item")
map("n", "[q", "<cmd>cprev<cr>zz", "Prev quickfix item")
map("n", "<leader>cm", "<cmd>make! | cwindow<cr>", "Build with :make (errors -> quickfix)")

-- diagnostics: jump and show the message in a float
local function jump(count, severity)
  return function()
    if vim.diagnostic.jump({ count = count, severity = severity }) then
      vim.diagnostic.open_float({ scope = "cursor", focus = false })
    end
  end
end
local ERROR = vim.diagnostic.severity.ERROR
map("n", "gl", vim.diagnostic.open_float, "Line diagnostics")
map("n", "]d", jump(1), "Next diagnostic")
map("n", "[d", jump(-1), "Prev diagnostic")
map("n", "]e", jump(1, ERROR), "Next error")
map("n", "[e", jump(-1, ERROR), "Prev error")

-- UI toggles
map("n", "<leader>uw", function()
  util.toggle("wrap", function() return vim.wo.wrap end, function(v) vim.wo.wrap = v end)
end, "Toggle line wrap")
map("n", "<leader>us", function()
  util.toggle("spell", function() return vim.wo.spell end, function(v) vim.wo.spell = v end)
end, "Toggle spell check")
map("n", "<leader>ud", function()
  util.toggle("diagnostics", vim.diagnostic.is_enabled, vim.diagnostic.enable)
end, "Toggle diagnostics")
map("n", "<leader>ul", function()
  local lines = not vim.diagnostic.config().virtual_lines
  vim.diagnostic.config({ virtual_lines = lines, virtual_text = not lines })
end, "Toggle full diagnostic messages")
map("n", "<leader>ub", function()
  vim.o.background = vim.o.background == "light" and "dark" or "light"
end, "Toggle light/dark theme")

-- scripts
map("n", "<leader>xc", "<cmd>!chmod +x %<cr>", "Make file executable")
