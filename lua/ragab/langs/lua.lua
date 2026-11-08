-- Lua (mainly for editing this config).
return {
  parsers = { "lua", "luadoc", "vim", "vimdoc", "query" },

  servers = {
    lua_ls = {
      settings = {
        Lua = {
          completion = { callSnippet = "Disable" }, -- no argument placeholders
          hint = { enable = true, setType = true, arrayIndex = "Disable" },
          workspace = { checkThirdParty = false },
        },
      },
    },
  },

  formatters = { lua = { "stylua" } },

  tools = { "lua-language-server", "stylua" },

  plugins = {
    -- types for vim.* and installed plugins while editing the config
    {
      "folke/lazydev.nvim",
      ft = "lua",
      opts = { library = { { path = "${3rd}/luv/library", words = { "vim%.uv" } } } },
    },
  },
}
