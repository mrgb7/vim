-- Python: basedpyright (auto-import completion, no call placeholders) + ruff.
-- On save: ruff --fix (removes unused imports, F401), sort imports, format.
return {
  indent = { python = { tab = false, width = 4 } },

  parsers = { "python" },

  servers = {
    basedpyright = {
      settings = {
        basedpyright = {
          disableOrganizeImports = true, -- ruff does it
          analysis = {
            autoImportCompletions = true,
            typeCheckingMode = "standard",
          },
        },
      },
    },
    ruff = true,
  },

  formatters = { python = { "ruff_fix", "ruff_organize_imports", "ruff_format" } },

  tools = { "basedpyright", "ruff" },
}
