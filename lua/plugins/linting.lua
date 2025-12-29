return {
  {
    "mfussenegger/nvim-lint",
    event = { "BufWritePost", "BufReadPost", "InsertLeave" },
    opts = {
      linters_by_ft = {
        dockerfile = { "hadolint" },
        go = { "golangcilint" },
        lua = { "selene" },
        markdown = { "markdownlint-cli2" },
        yaml = { "yamllint" },
      },
    },
    config = function(_, opts)
      local lint = require("lint")
      lint.linters_by_ft = opts.linters_by_ft
      local lint_augroup = vim.api.nvim_create_augroup("linting", { clear = true })
      vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
        group = lint_augroup,
        callback = function()
          -- Skip linting for Helm template files
          local filepath = vim.api.nvim_buf_get_name(0)
          if filepath:match("/templates/") or filepath:match("/charts/") or filepath:match("%.tpl$") then
            return
          end
          lint.try_lint()
        end,
      })
    end,
  },
}

