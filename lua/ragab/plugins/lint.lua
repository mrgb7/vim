-- Linters not covered by a language server (shellcheck runs inside bashls, Helm has none on purpose).
local langs = require("ragab.langs")

return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPost", "BufNewFile" },
  keys = {
    { "<leader>ll", function() require("lint").try_lint() end, desc = "Lint current file" },
  },
  config = function()
    local lint = require("lint")
    lint.linters_by_ft = langs.map("linters")
    local conditions = langs.map("lint_condition")

    vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost", "InsertLeave" }, {
      group = require("ragab.util").augroup("lint"),
      callback = function(ev)
        local cond = conditions[vim.bo[ev.buf].filetype]
        if cond and not cond(ev.buf) then
          return
        end
        lint.try_lint(nil, { ignore_errors = true })
      end,
    })
  end,
}
