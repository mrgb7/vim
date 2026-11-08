-- File explorer (nvim-tree replaces netrw) and fuzzy finding (Telescope).
--
-- nvim-tree default keys inside the tree: a = create file / dir (end with /),
-- d = delete, r = rename, x / c / p = cut / copy / paste, y = copy name, g? = help.
return {
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      -- renaming / moving files in the tree updates imports through the LSP
      { "antosha417/nvim-lsp-file-operations", dependencies = { "nvim-lua/plenary.nvim" }, opts = {} },
    },
    cmd = { "NvimTreeToggle", "NvimTreeFindFileToggle" },
    keys = {
      { "<leader>ee", "<cmd>NvimTreeToggle<cr>", desc = "Toggle file explorer" },
      { "<leader>ef", "<cmd>NvimTreeFindFileToggle<cr>", desc = "Reveal current file" },
      { "<leader>ec", "<cmd>NvimTreeCollapse<cr>", desc = "Collapse explorer" },
      { "<leader>er", "<cmd>NvimTreeRefresh<cr>", desc = "Refresh explorer" },
    },
    opts = {
      view = { width = 35, relativenumber = true },
      renderer = {
        indent_markers = { enable = true },
        icons = { glyphs = { folder = { arrow_closed = "", arrow_open = "" } } },
      },
      actions = { open_file = { window_picker = { enable = false } } },
      filters = { custom = { "^.DS_Store$" } },
      git = { ignore = false }, -- show gitignored files (dimmed)
    },
  },

  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      "nvim-telescope/telescope-ui-select.nvim", -- vim.ui.select (code actions, ...) in Telescope
    },
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
      { "<leader>fc", "<cmd>Telescope grep_string<cr>", mode = { "n", "x" }, desc = "Grep word / selection" },
      { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent files" },
      { "<leader>fb", "<cmd>Telescope buffers sort_mru=true<cr>", desc = "Buffers" },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help tags" },
      { "<leader>fk", "<cmd>Telescope keymaps<cr>", desc = "Keymaps" },
      { "<leader>fd", "<cmd>Telescope diagnostics<cr>", desc = "Workspace diagnostics" },
      { "<leader>f/", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Search in buffer" },
      { "<leader>f.", "<cmd>Telescope resume<cr>", desc = "Resume last picker" },
      { "<leader>fG", "<cmd>Telescope git_status<cr>", desc = "Git changed files" },
      { "<leader>ft", "<cmd>TodoTelescope<cr>", desc = "TODOs" },
    },
    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")

      telescope.setup({
        defaults = {
          path_display = { "truncate" },
          sorting_strategy = "ascending",
          layout_config = { prompt_position = "top", width = 0.9, height = 0.85 },
          file_ignore_patterns = { "^.git/", "node_modules/", "vendor/", "%.o$", "%.a$", "%.so$" },
          mappings = {
            i = {
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
            },
          },
        },
        pickers = {
          find_files = {
            find_command = { "fd", "--type", "f", "--hidden", "--strip-cwd-prefix", "--exclude", ".git" },
          },
          live_grep = { additional_args = { "--hidden", "--glob", "!.git/" } },
        },
        extensions = {
          ["ui-select"] = { require("telescope.themes").get_dropdown() },
        },
      })
      telescope.load_extension("fzf")
      telescope.load_extension("ui-select")
    end,
  },
}
