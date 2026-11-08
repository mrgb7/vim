-- Markdown (READMEs, runbooks) plus the misc parsers every buffer benefits from.
return {
  parsers = {
    "markdown", "markdown_inline", "comment", "regex", "diff",
    "git_config", "gitcommit", "git_rebase", "gitignore", "gitattributes",
    "ssh_config", "nginx", "ini", "sql", "xml", "html",
  },

  servers = { marksman = true },

  formatters = { markdown = { "prettier" } },

  linters = { markdown = { "markdownlint" } },

  tools = { "marksman", "prettier", "markdownlint" },
}
