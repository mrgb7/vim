-- Go: gopls (auto-import completion, no placeholders), goimports + gofumpt on save
-- (adds missing / removes unused imports), golangci-lint, delve, go.nvim helpers.
return {
  indent = {
    go = { tab = true, width = 4 }, -- gofmt uses tabs
    gomod = { tab = true, width = 4 },
    gowork = { tab = true, width = 4 },
  },

  parsers = { "go", "gomod", "gosum", "gowork", "gotmpl" },

  servers = {
    gopls = {
      settings = {
        gopls = {
          usePlaceholders = false, -- complete `fmt.Println` without argument placeholders
          completeUnimported = true, -- offer (and auto-import) packages that aren't imported yet
          gofumpt = true,
          staticcheck = true,
          semanticTokens = true,
          directoryFilters = { "-.git", "-node_modules", "-vendor" },
          analyses = {
            nilness = true,
            shadow = true,
            unusedparams = true,
            unusedvariable = true,
            unusedwrite = true,
          },
          hints = {
            assignVariableTypes = true,
            compositeLiteralFields = true,
            constantValues = true,
            functionTypeParameters = true,
            parameterNames = true,
            rangeVariableTypes = true,
          },
          codelenses = {
            generate = true,
            test = true,
            tidy = true,
            upgrade_dependency = true,
            vendor = true,
            run_govulncheck = true,
          },
        },
      },
    },
  },

  formatters = { go = { "goimports", "gofumpt" } },

  linters = { go = { "golangcilint" } },
  -- golangci-lint works on whole packages: only run outside insert mode inside a module
  lint_condition = {
    go = function(buf)
      return vim.fn.mode() ~= "i" and vim.fs.root(buf, "go.mod") ~= nil
    end,
  },

  tools = {
    "gopls", "goimports", "gofumpt", "golangci-lint", "delve",
    -- used by go.nvim commands
    "gomodifytags", "impl", "iferr", "gotests", "json-to-struct",
  },

  ftplugin = {
    filetypes = { "go" },
    setup = function(_, map)
      map("n", "<localleader>r", "<cmd>GoRun<cr>", "Go: run")
      map("n", "<localleader>b", "<cmd>GoBuild<cr>", "Go: build")
      map("n", "<localleader>t", "<cmd>GoTestFunc -v<cr>", "Go: test function")
      map("n", "<localleader>T", "<cmd>GoTestFile -v<cr>", "Go: test file")
      map("n", "<localleader>p", "<cmd>GoTestPkg<cr>", "Go: test package")
      map("n", "<localleader>g", "<cmd>GoAddTest<cr>", "Go: generate test for function")
      map("n", "<localleader>c", "<cmd>GoCoverage<cr>", "Go: toggle coverage")
      map("n", "<localleader>a", "<cmd>GoAlt!<cr>", "Go: switch test/impl file")
      map("n", "<localleader>e", "<cmd>GoIfErr<cr>", "Go: insert if err")
      map("n", "<localleader>j", "<cmd>GoTagAdd json<cr>", "Go: add json tags")
      map("n", "<localleader>y", "<cmd>GoTagAdd yaml<cr>", "Go: add yaml tags")
      map("n", "<localleader>J", "<cmd>GoTagRm json<cr>", "Go: remove json tags")
      map("n", "<localleader>i", "<cmd>GoImpl<cr>", "Go: implement interface")
      map("n", "<localleader>f", "<cmd>GoFillStruct<cr>", "Go: fill struct")
      map("n", "<localleader>m", "<cmd>GoModTidy<cr>", "Go: mod tidy")
      map("n", "<localleader>l", "<cmd>GoLint<cr>", "Go: golangci-lint project")
      map("n", "<localleader>v", function()
        vim.lsp.codelens.run()
      end, "Go: run code lens (test / tidy / govulncheck)")
    end,
  },

  plugins = {
    {
      "ray-x/go.nvim",
      ft = { "go", "gomod", "gowork", "gotmpl" },
      dependencies = { "ray-x/guihua.lua" },
      -- LSP, formatting, linting and debugging are handled elsewhere; only the helpers are used.
      -- Its binaries come from Mason (see `tools` above), so there's no build step.
      opts = {
        lsp_cfg = false,
        lsp_keymaps = false,
        lsp_codelens = false,
        lsp_inlay_hints = { enable = false },
        diagnostic = false,
        dap_debug = false,
        textobjects = false,
        luasnip = true,
        trouble = true,
        test_runner = "go",
        run_in_floaterm = true,
      },
    },
  },
}
