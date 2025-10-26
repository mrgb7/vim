return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    cmd = { "ToggleTerm", "TermExec" },
    keys = {
      { "<leader>tt", "<cmd>ToggleTerm<cr>", desc = "Toggle Terminal" },
    },
    opts = {
      size = 20,
      hide_numbers = true,
      start_in_insert = true,
      insert_mappings = true,
      persist_size = true,
      direction = "float",
      close_on_exit = true,
      shell = vim.o.shell,
      float_opts = {
        border = "curved",
        winblend = 0,
        highlights = {
          border = "Normal",
          background = "Normal",
        },
      },
    },
    config = function(_, opts)
      require("toggleterm").setup(opts)

      function _G.set_terminal_keymaps()
        local kopts = {buffer = 0}
        vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], kopts)
        vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], kopts)
        vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], kopts)
        vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], kopts)
        vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], kopts)
      end

      vim.cmd('autocmd! TermOpen term://*toggleterm#* lua set_terminal_keymaps()')
    end,
  },
}