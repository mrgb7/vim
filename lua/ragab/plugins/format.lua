-- Format on save with conform.nvim. Formatters per language come from lua/ragab/langs.
local langs = require("ragab.langs")

return {
  "stevearc/conform.nvim",
  event = "BufWritePre",
  cmd = "ConformInfo",
  keys = {
    {
      "<leader>cf",
      function()
        require("conform").format({ async = true })
      end,
      mode = { "n", "x" },
      desc = "Format buffer / selection",
    },
    {
      "<leader>uf",
      function()
        vim.g.disable_autoformat = not vim.g.disable_autoformat
        vim.notify("format on save " .. (vim.g.disable_autoformat and "off" or "on"))
      end,
      desc = "Toggle format on save",
    },
  },
  init = function()
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()" -- gq uses the formatter
  end,
  opts = function()
    return {
      formatters_by_ft = vim.tbl_extend("force", langs.map("formatters"), {
        ["_"] = { "trim_whitespace" }, -- filetypes without a formatter
      }),
      formatters = langs.map("formatter_opts"),
      default_format_opts = { lsp_format = "fallback", timeout_ms = 2000 },
      format_on_save = function(buf)
        if vim.g.disable_autoformat or vim.b[buf].disable_autoformat then
          return
        end
        return {}
      end,
    }
  end,
}
