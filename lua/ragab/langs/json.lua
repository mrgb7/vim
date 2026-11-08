-- JSON / JSONC: jsonls with the SchemaStore catalog, prettier on save.
return {
  parsers = { "json", "jq" },

  servers = {
    jsonls = function()
      return {
        settings = {
          json = {
            schemas = require("schemastore").json.schemas(),
            validate = { enable = true },
          },
        },
      }
    end,
  },

  formatters = { json = { "prettier" }, jsonc = { "prettier" } },

  tools = { "json-lsp", "prettier", "jq" },
}
