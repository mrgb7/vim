return {
  "akinsho/toggleterm.nvim",
  version = "*",
  cmd = { "ToggleTerm", "TermExec", "TermSelect" },
  keys = {
    { [[<C-\>]], desc = "Toggle terminal" },
    { "<leader>tt", "<cmd>ToggleTerm direction=float<cr>", desc = "Floating terminal" },
    { "<leader>tv", "<cmd>ToggleTerm size=80 direction=vertical<cr>", desc = "Vertical terminal" },
    { "<leader>ts", "<cmd>TermSelect<cr>", desc = "Select terminal" },
    { "<leader>tl", "<cmd>ToggleTermSendCurrentLine<cr>", desc = "Send line to terminal" },
    { "<leader>tl", "<cmd>ToggleTermSendVisualSelection<cr>", mode = "x", desc = "Send selection to terminal" },
  },
  opts = {
    size = 20,
    open_mapping = [[<C-\>]],
    shade_terminals = true,
    direction = "horizontal",
    float_opts = { border = "curved" },
    -- toggleterm buffers only, so lazygit / k9s / htop keep their own <Esc>, jk and <C-hjkl>
    on_create = function(term)
      local opts = { buffer = term.bufnr }
      vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], opts)
      vim.keymap.set("t", "jk", [[<C-\><C-n>]], opts)
      vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<cr>]], opts)
      vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<cr>]], opts)
      vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<cr>]], opts)
      vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<cr>]], opts)
    end,
  },
}
