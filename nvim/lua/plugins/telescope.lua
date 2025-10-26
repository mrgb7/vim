return {
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        cond = function()
          return vim.fn.executable("make") == 1
        end,
      },
    },
    cmd = "Telescope",
    event = "VeryLazy",
    opts = {
      defaults = {
        prompt_prefix = " ",
        selection_caret = " ",
        mappings = {
          i = {
            ["<C-n>"] = "move_selection_next",
            ["<C-p>"] = "move_selection_previous",
            ["<C-c>"] = "close",
            ["<Down>"] = "move_selection_next",
            ["<Up>"] = "move_selection_previous",
            ["<CR>"] = "select_default",
            ["<C-x>"] = "select_horizontal",
            ["<C-v>"] = "select_vertical",
            ["<C-t>"] = "select_tab",
            ["<C-u>"] = "preview_scrolling_up",
            ["<C-d>"] = "preview_scrolling_down",
            ["<PageUp>"] = "results_scrolling_up",
            ["<PageDown>"] = "results_scrolling_down",
            ["<Tab>"] = "toggle_selection",
            ["<S-Tab>"] = "toggle_selection",
            ["<C-q>"] = "send_to_qflist",
            ["<M-q>"] = "send_selected_to_qflist",
            ["<C-l>"] = "complete_tag",
            ["<C-_>"] = "which_key",
          },
          n = {
            ["<esc>"] = "close",
            ["<CR>"] = "select_default",
            ["<C-x>"] = "select_horizontal",
            ["<C-v>"] = "select_vertical",
            ["<C-t>"] = "select_tab",
            ["<Tab>"] = "toggle_selection",
            ["<S-Tab>"] = "toggle_selection",
            ["<C-q>"] = "send_to_qflist",
            ["<M-q>"] = "send_selected_to_qflist",
            ["j"] = "move_selection_next",
            ["k"] = "move_selection_previous",
            ["H"] = "move_to_top",
            ["M"] = "move_to_middle",
            ["L"] = "move_to_bottom",
            ["<Down>"] = "move_selection_next",
            ["<Up>"] = "move_selection_previous",
            ["gg"] = "move_to_top",
            ["G"] = "move_to_bottom",
            ["<C-u>"] = "preview_scrolling_up",
            ["<C-d>"] = "preview_scrolling_down",
            ["<PageUp>"] = "results_scrolling_up",
            ["<PageDown>"] = "results_scrolling_down",
            ["?"] = "which_key",
          },
        },
      },
      pickers = {
        find_files = {
          find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
        },
      },
      extensions = {
        fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = "smart_case",
        },
      },
    },
    config = function(_, opts)
      require("telescope").setup(opts)
      require("telescope").load_extension("fzf")
    end,
  },
}