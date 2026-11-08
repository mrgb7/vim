-- Editing and navigation helpers.
-- Commenting is built in (gc / gcc) and uses treesitter, so no comment plugin is needed.
return {
  { "nvim-lua/plenary.nvim", lazy = true },

  -- <C-h/j/k/l> move across nvim splits and tmux panes
  {
    "christoomey/vim-tmux-navigator",
    init = function()
      vim.g.tmux_navigator_no_mappings = 1
    end,
    keys = {
      { "<C-h>", "<cmd>TmuxNavigateLeft<cr>", desc = "Window left" },
      { "<C-j>", "<cmd>TmuxNavigateDown<cr>", desc = "Window down" },
      { "<C-k>", "<cmd>TmuxNavigateUp<cr>", desc = "Window up" },
      { "<C-l>", "<cmd>TmuxNavigateRight<cr>", desc = "Window right" },
    },
  },

  -- ys / ds / cs: add / delete / change surroundings
  { "kylechui/nvim-surround", version = "*", event = "VeryLazy", opts = {} },

  -- s / S: jump anywhere on screen / select a treesitter node
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = { modes = { search = { enabled = false } } },
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash jump" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash treesitter" },
    },
  },

  -- quick file marks
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
    keys = function()
      local function list()
        return require("harpoon"):list()
      end
      local keys = {
        { "<leader>ha", function() list():add() end, desc = "Harpoon: add file" },
        { "<leader>hl", function() require("harpoon").ui:toggle_quick_menu(list()) end, desc = "Harpoon: list" },
      }
      for i = 1, 4 do
        keys[#keys + 1] = { "<leader>" .. i, function() list():select(i) end, desc = "Harpoon: file " .. i }
      end
      return keys
    end,
  },

  -- TODO / FIXME / HACK highlighting and navigation
  {
    "folke/todo-comments.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
    keys = {
      { "]t", function() require("todo-comments").jump_next() end, desc = "Next TODO" },
      { "[t", function() require("todo-comments").jump_prev() end, desc = "Prev TODO" },
    },
  },

  -- diagnostics / symbols / quickfix panels
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    opts = {},
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Workspace diagnostics" },
      { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer diagnostics" },
      { "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix list" },
      { "<leader>xL", "<cmd>Trouble loclist toggle<cr>", desc = "Location list" },
      { "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "Symbols panel" },
      { "<leader>cl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", desc = "LSP references panel" },
    },
  },

  -- per-directory sessions
  {
    "rmagatti/auto-session",
    lazy = false,
    keys = {
      { "<leader>wr", "<cmd>AutoSession restore<cr>", desc = "Restore session" },
      { "<leader>ws", "<cmd>AutoSession save<cr>", desc = "Save session" },
      { "<leader>wf", "<cmd>AutoSession search<cr>", desc = "Find session" },
    },
    opts = {
      auto_restore = false,
      suppressed_dirs = { "~/", "~/Dev/", "~/Downloads", "/tmp" },
      bypass_save_filetypes = { "alpha", "NvimTree" },
    },
  },
}
