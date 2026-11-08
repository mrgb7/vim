-- Language servers + Mason (installs every server/formatter/linter/debugger listed in lua/ragab/langs).
return {
  {
    "neovim/nvim-lspconfig", -- server definitions only; configuration is in lua/ragab/lsp.lua
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "b0o/schemastore.nvim",
    },
    config = function()
      require("ragab.lsp").setup()
    end,
  },
  {
    "mason-org/mason.nvim",
    cmd = "Mason",
    build = ":MasonUpdate",
    opts = {
      ui = {
        border = "rounded",
        icons = { package_installed = "✓", package_pending = "➜", package_uninstalled = "✗" },
      },
    },
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    event = "VeryLazy",
    dependencies = { "mason-org/mason.nvim" },
    opts = function()
      return {
        ensure_installed = require("ragab.langs").list("tools"),
        run_on_start = true,
        start_delay = 3000,
      }
    end,
  },
}
