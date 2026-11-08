-- Diagnostics UI, shared by LSP servers and nvim-lint.
local severity = vim.diagnostic.severity

vim.diagnostic.config({
  severity_sort = true,
  underline = true,
  update_in_insert = false,
  virtual_text = { spacing = 2, source = "if_many", prefix = "●" },
  virtual_lines = false, -- <leader>ul shows full multi-line messages (long compiler errors)
  float = { border = "rounded", source = true },
  signs = {
    text = {
      [severity.ERROR] = " ",
      [severity.WARN] = " ",
      [severity.HINT] = "󰠠 ",
      [severity.INFO] = " ",
    },
  },
})
