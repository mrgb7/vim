return {
  {
    "stevearc/conform.nvim",
    dependencies = { "mason.nvim" },
    event = { "BufReadPre", "BufNewFile" },
    cmd = "ConformInfo",
    keys = {
      {
        "<leader>cF",
        function()
          require("conform").format({ formatters = { "injected" } })
        end,
        mode = { "n", "v" },
        desc = "Format Injected Langs",
      },
    },
    init = function()
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        go = { "goimports", "gofumpt" },
        python = { "isort", "black" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
        bash = { "shfmt" },
        sh = { "shfmt" },
      },
      format_on_save = function(bufnr)
        local disable_filetypes = { c = true, cpp = true }
        return {
          timeout_ms = 500,
          lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
        }
      end,
      formatters = {
        shfmt = {
          prepend_args = { "-i", "2" },
        },
        goimports = {
          command = "goimports",
        },
      },
    },
    config = function(_, opts)
      require("conform").setup(opts)

      -- Manual format command for YAML and Helm
      vim.api.nvim_create_user_command("Format", function()
        require("conform").format()
      end, { desc = "Format current buffer" })

      -- Single shortcut for format and import
      vim.keymap.set({ "n", "v" }, "<leader>f", function()
        require("conform").format()
      end, { desc = "Format and organize imports" })
    end,
  },

  -- Alternative: null-ls for additional linting/formatting
  {
    "jose-elias-alvarez/null-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "mason.nvim" },
    enabled = false, -- Disable by default since conform is active
    opts = function()
      local nls = require("null-ls")
      return {
        root_dir = require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", "Makefile", ".git"),
        sources = {
          -- Go
          nls.builtins.formatting.goimports,
          nls.builtins.formatting.gofumpt,
          nls.builtins.diagnostics.golangci_lint,

          -- Python
          nls.builtins.formatting.black,
          nls.builtins.formatting.isort,

          -- JavaScript/TypeScript
          nls.builtins.formatting.prettier,

          -- Lua
          nls.builtins.formatting.stylua,

          -- Shell
          nls.builtins.formatting.shfmt,
        },
      }
    end,
  },
}