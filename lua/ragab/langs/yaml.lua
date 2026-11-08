-- YAML (Kubernetes, CI), Helm charts and GitHub Actions.
--
-- Helm templates (`helm`) go to helm_ls only: it wraps yamlls for completion but
-- with yamlls diagnostics and `helm lint` disabled, so templates show no linter
-- warnings. They are not reformatted (prettier would break the Go templating),
-- only trailing whitespace is trimmed. values*.yaml next to a Chart.yaml is
-- `yaml.helm-values`: helm_ls completion + prettier, but no yamllint.
local function in_chart(path)
  return vim.fs.find("Chart.yaml", { upward = true, path = vim.fs.dirname(path) })[1] ~= nil
end

return {
  detect = {
    pattern = {
      [".*/templates/.*%.ya?ml"] = function(path)
        return in_chart(path) and "helm" or nil
      end,
      [".*/templates/.*%.tpl"] = "helm",
      [".*/values[^/]*%.ya?ml"] = function(path)
        local dir = vim.fs.dirname(path)
        return vim.uv.fs_stat(dir .. "/Chart.yaml") and "yaml.helm-values" or nil
      end,
      [".*/%.github/workflows/.*%.ya?ml"] = "yaml.github",
    },
  },

  parsers = { "yaml", "helm" },

  servers = {
    yamlls = function()
      return {
        filetypes = { "yaml", "yaml.docker-compose", "yaml.github", "yaml.gitlab" },
        settings = {
          yaml = {
            -- schemastore.nvim provides the catalog; the built-in download is disabled
            schemaStore = { enable = false, url = "" },
            schemas = vim.tbl_extend("force", require("schemastore").yaml.schemas(), {
              kubernetes = {
                "**/k8s/**/*.yaml",
                "**/kubernetes/**/*.yaml",
                "**/manifests/**/*.yaml",
                "**/deploy/**/*.yaml",
                "**/kustomize/**/*.yaml",
              },
            }),
            validate = true,
            completion = true,
            hover = true,
            format = { enable = false }, -- prettier via conform
            keyOrdering = false,
            customTags = {
              -- CloudFormation / AWS SAM
              "!Ref scalar", "!Sub scalar", "!Sub sequence", "!GetAtt scalar", "!GetAtt sequence",
              "!Join sequence", "!Select sequence", "!If sequence", "!Equals sequence", "!And sequence",
              "!Or sequence", "!Not sequence", "!Condition scalar", "!FindInMap sequence", "!GetAZs scalar",
              "!ImportValue scalar", "!Base64 scalar", "!Cidr sequence", "!Split sequence", "!Transform mapping",
              "!reference sequence", -- GitLab CI
            },
          },
          redhat = { telemetry = { enabled = false } },
        },
      }
    end,
    helm_ls = {
      settings = {
        ["helm-ls"] = {
          helmLint = { enabled = false },
          yamlls = {
            enabled = true, -- keep schema-based completion inside templates
            path = "yaml-language-server",
            diagnosticsLimit = 0, -- ...but no yaml diagnostics
            showDiagnosticsDirectly = false,
          },
        },
      },
    },
  },

  formatters = {
    yaml = { "prettier" },
    ["yaml.helm-values"] = { "prettier" },
  },

  linters = {
    yaml = { "yamllint" },
    ["yaml.github"] = { "actionlint", "yamllint" },
    ["yaml.helm-values"] = {}, -- exact match wins over the `yaml` part: no yamllint
  },

  tools = { "yaml-language-server", "helm-ls", "prettier", "yamllint", "actionlint" },

  ftplugin = {
    filetypes = { "helm" },
    setup = function(buf)
      vim.bo[buf].commentstring = "{{/* %s */}}"
      vim.bo[buf].expandtab = true
      vim.bo[buf].shiftwidth = 2
    end,
  },
}
