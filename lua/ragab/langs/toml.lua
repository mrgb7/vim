-- TOML (Cargo, pyproject, golangci, ...) via taplo.
return {
  parsers = { "toml" },
  servers = { taplo = true },
  formatters = { toml = { "taplo" } },
  tools = { "taplo" },
}
