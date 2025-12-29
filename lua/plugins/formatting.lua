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
        -- Style from reference: isort + ruff_format for Python
        python = { "isort", "ruff_format" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
        json = { "prettier" },
        -- Use yamlfmt (style-aligned) instead of prettier for YAML
        yaml = { "yamlfmt" },
        -- Add markdownlint alongside prettier for Markdown
        markdown = { "prettier", "markdownlint-cli2" },
        bash = { "shfmt" },
        sh = { "shfmt" },
      },
      format_on_save = function(bufnr)
        -- Respect global autoformat toggle
        if not vim.g.autoformat then
          return
        end
        local disable_filetypes = { c = true, cpp = true, helm = true }
        -- Disable for Helm template files (files in templates/ or charts/ directories)
        local filepath = vim.api.nvim_buf_get_name(bufnr)
        if filepath:match("/templates/") or filepath:match("/charts/") or filepath:match("%.tpl$") then
          return
        end
        return {
          timeout_ms = 500,
          lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
        }
      end,
      formatters = {
        shfmt = {
          prepend_args = { "-i", "2" },
        },
        -- Ensure consistent Lua formatting without needing a stylua config file
        stylua = {
          prepend_args = { "--indent-type", "Spaces", "--indent-width", "2" },
        },
        -- Align YAML formatting behavior to reference config
        yamlfmt = {
          prepend_args = { "-formatter", "indent=2,include_document_start=true,retain_line_breaks_single=true" },
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

      -- Toggle format-on-save globally (style-aligned with reference)
      vim.api.nvim_create_user_command("ToggleAutoformat", function()
        vim.g.autoformat = vim.g.autoformat == false and true or false
        vim.api.nvim_notify("Autoformat: " .. (vim.g.autoformat and "ON" or "OFF"), vim.log.levels.INFO,
          { title = "conform.nvim", timeout = 2000 })
      end, { desc = "Toggle format on save" })
      vim.keymap.set("n", "<leader>tF", "<cmd>ToggleAutoformat<cr>", { desc = "Toggle format on save" })
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
