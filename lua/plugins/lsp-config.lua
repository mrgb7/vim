return {
  {
    "williamboman/mason.nvim",
    lazy = false,
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    lazy = false,
    config = function()
      require("mason-lspconfig").setup({
        auto_install = true,
        ensure_installed = { "gopls", "pylsp", "yamlls", "bashls" },
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    config = function()
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      -- Setup keymaps on LSP attach
      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(args)
          local bufnr = args.buf
          vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr })
          vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, { buffer = bufnr })
          vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, { buffer = bufnr })
          vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, { buffer = bufnr })
          vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = bufnr })
          vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { buffer = bufnr })
          vim.keymap.set('n', '<leader>rf', vim.lsp.buf.code_action, { buffer = bufnr, desc = "Refactor" })
          vim.keymap.set('n', '<leader>re', vim.lsp.buf.rename, { buffer = bufnr, desc = "Rename" })
          vim.keymap.set("n", "<leader>de", vim.diagnostic.open_float, { buffer = bufnr, desc = "Show diagnostics" })
          vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { buffer = bufnr, desc = "Previous error" })
          vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { buffer = bufnr, desc = "Next error" })

          -- Visual mode code actions
          vim.keymap.set("v", "<leader>ca", function()
            vim.lsp.buf.code_action({ range = {
              start = { vim.fn.line("'<") - 1, vim.fn.col("'<") - 1 },
              ['end'] = { vim.fn.line("'>") - 1, vim.fn.col("'>") }
            }})
          end, { buffer = bufnr })
          vim.keymap.set("v", "<leader>rf", function()
            vim.lsp.buf.code_action({ range = {
              start = { vim.fn.line("'<") - 1, vim.fn.col("'<") - 1 },
              ['end'] = { vim.fn.line("'>") - 1, vim.fn.col("'>") }
            }})
          end, { buffer = bufnr, desc = "Refactor" })
        end,
      })

      -- Golang LSP using new vim.lsp.config API
      vim.lsp.config('gopls', {
        cmd = { 'gopls' },
        capabilities = capabilities,
        settings = {
          gopls = {
            analyses = {
              unusedparams = true,
              unreachable = true,
            },
            staticcheck = true,
            gofumpt = true,
            usePlaceholders = false,
            completeUnimported = true,
            directoryFilters = { '-.git', '-.vscode', '-.idea', '-node_modules' },
            semanticTokens = true,
            vulncheck = 'Imports',
          },
        },
      })

      -- Python LSP
      vim.lsp.config('pylsp', {
        cmd = { 'pylsp' },
        capabilities = capabilities,
        settings = {
          pylsp = {
            plugins = {
              pycodestyle = { enabled = false },
              mccabe = { enabled = false },
              pyflakes = { enabled = false },
              flake8 = { enabled = true },
              autopep8 = { enabled = true },
              yapf = { enabled = false },
              black = { enabled = true, line_length = 88 },
            }
          }
        }
      })

      -- YAML LSP
      vim.lsp.config('yamlls', {
        cmd = { 'yaml-language-server', '--stdio' },
        capabilities = capabilities,
        settings = {
          yaml = {
            schemaStore = {
              enable = true,
            },
            validate = true,
          },
        }
      })

      -- Bash LSP
      vim.lsp.config('bashls', {
        cmd = { 'bash-language-server', 'start' },
        capabilities = capabilities,
      })

      -- Enable all servers
      vim.lsp.enable({ 'gopls', 'pylsp', 'yamlls', 'bashls' })
    end,
  },
}
