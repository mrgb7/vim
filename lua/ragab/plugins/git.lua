return {
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      current_line_blame_opts = { delay = 300 },
      on_attach = function(buf)
        local gs = require("gitsigns")
        local function map(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = buf, desc = desc })
        end
        local function nav(dir, key)
          return function()
            if vim.wo.diff then
              vim.cmd.normal({ key, bang = true })
            else
              gs.nav_hunk(dir)
            end
          end
        end
        local function range()
          return { vim.fn.line("."), vim.fn.line("v") }
        end

        map("n", "]c", nav("next", "]c"), "Next hunk")
        map("n", "[c", nav("prev", "[c"), "Prev hunk")
        map("n", "<leader>gs", gs.stage_hunk, "Stage hunk")
        map("n", "<leader>gr", gs.reset_hunk, "Reset hunk")
        map("x", "<leader>gs", function() gs.stage_hunk(range()) end, "Stage selection")
        map("x", "<leader>gr", function() gs.reset_hunk(range()) end, "Reset selection")
        map("n", "<leader>gS", gs.stage_buffer, "Stage buffer")
        map("n", "<leader>gR", gs.reset_buffer, "Reset buffer")
        map("n", "<leader>gp", gs.preview_hunk_inline, "Preview hunk")
        map("n", "<leader>gb", function() gs.blame_line({ full = true }) end, "Blame line")
        map("n", "<leader>gB", gs.toggle_current_line_blame, "Toggle inline blame")
        map("n", "<leader>gD", gs.diffthis, "Diff against index")
        map({ "o", "x" }, "ih", gs.select_hunk, "Inner hunk")
      end,
    },
  },
  -- :Git status window: s / u stage / unstage, = inline diff, cc commit, ca amend, g? help
  {
    "tpope/vim-fugitive",
    cmd = { "Git", "G", "Gdiffsplit", "Gvdiffsplit", "Gclog", "Gread", "Gwrite", "Gedit", "GBrowse" },
    keys = {
      { "<leader>gg", "<cmd>Git<cr>", desc = "Git status" },
      { "<leader>gc", "<cmd>Git commit<cr>", desc = "Git commit" },
      { "<leader>gP", "<cmd>Git push<cr>", desc = "Git push" },
      { "<leader>gl", "<cmd>Git log --oneline --graph --decorate -50<cr>", desc = "Git log" },
      { "<leader>gh", "<cmd>0Gclog<cr>", desc = "File history (quickfix)" },
      { "<leader>gv", "<cmd>Gvdiffsplit<cr>", desc = "Diff split against index" },
    },
  },
}
