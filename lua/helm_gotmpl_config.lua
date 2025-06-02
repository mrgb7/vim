-- Enhanced configuration for Go templates, Helm, and YAML
-- This file contains specific configurations for gotmpl, helm, and enhanced yaml support

-- File type detection and associations
vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
  pattern = {"*.gotmpl", "*.gohtml", "*.tmpl", "*.tpl"},
  callback = function()
    vim.bo.filetype = "gotmpl"
    vim.bo.commentstring = "{{/* %s */}}"
  end
})

-- Helm template detection
vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
  pattern = {"*/templates/*.yaml", "*/templates/*.yml", "Chart.yaml", "values.yaml", "values.yml"},
  callback = function()
    vim.bo.filetype = "helm"
  end
})

-- Enhanced formatting on save for all template types
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = {"*.yaml", "*.yml", "*.gotmpl", "*.gohtml", "*.tmpl", "*.tpl"},
  callback = function()
    local bufnr = vim.api.nvim_get_current_buf()
    local filetype = vim.bo[bufnr].filetype
    
    -- Format YAML files
    if filetype == "yaml" or filetype == "helm" then
      vim.lsp.buf.format({ bufnr = bufnr, timeout_ms = 2000 })
    end
    
    -- Format Go template files
    if filetype == "gotmpl" then
      -- Use gofmt for Go template files if available
      local clients = vim.lsp.get_active_clients({ bufnr = bufnr })
      for _, client in ipairs(clients) do
        if client.name == "gopls" and client.server_capabilities.documentFormattingProvider then
          vim.lsp.buf.format({ bufnr = bufnr, timeout_ms = 2000 })
          break
        end
      end
    end
  end,
})

-- Helm-specific keybindings
vim.api.nvim_create_autocmd("FileType", {
  pattern = "helm",
  callback = function()
    local bufnr = vim.api.nvim_get_current_buf()
    
    -- Helm template validation
    vim.keymap.set('n', '<leader>hv', function()
      vim.cmd('TermExec cmd="helm template . --debug"')
    end, { desc = 'Validate Helm template', buffer = bufnr })
    
    -- Helm lint
    vim.keymap.set('n', '<leader>hl', function()
      vim.cmd('TermExec cmd="helm lint ."')
    end, { desc = 'Lint Helm chart', buffer = bufnr })
    
    -- Helm dependency update
    vim.keymap.set('n', '<leader>hd', function()
      vim.cmd('TermExec cmd="helm dependency update"')
    end, { desc = 'Update Helm dependencies', buffer = bufnr })
    
    -- Helm test
    vim.keymap.set('n', '<leader>ht', function()
      local chart_name = vim.fn.input("Chart release name: ")
      if chart_name ~= "" then
        vim.cmd('TermExec cmd="helm test ' .. chart_name .. '"')
      end
    end, { desc = 'Test Helm release', buffer = bufnr })
  end
})

-- Go template specific keybindings
vim.api.nvim_create_autocmd("FileType", {
  pattern = "gotmpl",
  callback = function()
    local bufnr = vim.api.nvim_get_current_buf()
    
    -- Go template syntax validation
    vim.keymap.set('n', '<leader>gt', function()
      local file = vim.fn.expand("%:p")
      vim.cmd('TermExec cmd="go run -tags tools ' .. file .. '"')
    end, { desc = 'Test Go template', buffer = bufnr })
  end
})

-- Enhanced syntax highlighting for Go templates
vim.api.nvim_create_autocmd("FileType", {
  pattern = "gotmpl",
  callback = function()
    -- Custom syntax highlighting for Go template constructs
    vim.cmd([[
      syntax region goTmplAction start="{{\s*" end="\s*}}" contains=goTmplKeyword,goTmplFunction,goTmplVariable
      syntax keyword goTmplKeyword if else end with range template define block include
      syntax keyword goTmplFunction printf print println len index slice html js css urlquery
      syntax match goTmplVariable /\$\w\+/
      syntax match goTmplPipe /|/
      syntax match goTmplComment /{{\/\*.*\*\/}}/
      
      highlight link goTmplAction Special
      highlight link goTmplKeyword Keyword
      highlight link goTmplFunction Function
      highlight link goTmplVariable Identifier
      highlight link goTmplPipe Operator
      highlight link goTmplComment Comment
    ]])
  end
})

-- YAML schema associations for better validation
local yaml_schemas = {
  -- Kubernetes
  ["https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.27.3-standalone-strict/all.json"] = {
    "*.k8s.yaml",
    "*.k8s.yml",
    "k8s/**/*.yaml",
    "k8s/**/*.yml",
    "kubernetes/**/*.yaml",
    "kubernetes/**/*.yml"
  },
  
  -- Helm
  ["https://json.schemastore.org/chart.json"] = "Chart.yaml",
  ["https://json.schemastore.org/chart-lock.json"] = "Chart.lock",
  
  -- Docker Compose
  ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = {
    "docker-compose*.yaml",
    "docker-compose*.yml",
    "compose*.yaml",
    "compose*.yml"
  },
  
  -- GitHub Actions
  ["https://json.schemastore.org/github-workflow.json"] = {
    ".github/workflows/*.yaml",
    ".github/workflows/*.yml"
  }
}

-- Auto-completion snippets for Go templates
local luasnip = require('luasnip')
local s = luasnip.snippet
local t = luasnip.text_node
local i = luasnip.insert_node

luasnip.add_snippets("gotmpl", {
  s("if", {
    t("{{ if "), i(1, "condition"), t(" }}"),
    t({"", "  "}), i(2, "content"),
    t({"", "{{ end }}"})
  }),
  
  s("range", {
    t("{{ range "), i(1, "$index, $value := .Items"), t(" }}"),
    t({"", "  "}), i(2, "content"),
    t({"", "{{ end }}"})
  }),
  
  s("with", {
    t("{{ with "), i(1, ".Field"), t(" }}"),
    t({"", "  "}), i(2, "content"),
    t({"", "{{ end }}"})
  }),
  
  s("template", {
    t("{{ template \""), i(1, "template-name"), t("\" "), i(2, "."), t(" }}")
  }),
  
  s("include", {
    t("{{ include \""), i(1, "template-name"), t("\" "), i(2, "."), t(" | indent "), i(3, "2"), t(" }}")
  })
})

-- Helm-specific snippets
luasnip.add_snippets("helm", {
  s("deployment", {
    t({
      "apiVersion: apps/v1",
      "kind: Deployment",
      "metadata:",
      "  name: {{ include \"chart.fullname\" . }}",
      "  labels:",
      "    {{- include \"chart.labels\" . | nindent 4 }}",
      "spec:",
      "  replicas: {{ .Values.replicaCount }}",
      "  selector:",
      "    matchLabels:",
      "      {{- include \"chart.selectorLabels\" . | nindent 6 }}",
      "  template:",
      "    metadata:",
      "      labels:",
      "        {{- include \"chart.selectorLabels\" . | nindent 8 }}",
      "    spec:",
      "      containers:",
      "      - name: {{ .Chart.Name }}",
      "        image: \"{{ .Values.image.repository }}:{{ .Values.image.tag }}\"",
      "        imagePullPolicy: {{ .Values.image.pullPolicy }}",
      "        ports:",
      "        - name: http",
      "          containerPort: "
    }),
    i(1, "8080"),
    t({"", "          protocol: TCP"})
  }),
  
  s("service", {
    t({
      "apiVersion: v1",
      "kind: Service",
      "metadata:",
      "  name: {{ include \"chart.fullname\" . }}",
      "  labels:",
      "    {{- include \"chart.labels\" . | nindent 4 }}",
      "spec:",
      "  type: {{ .Values.service.type }}",
      "  ports:",
      "    - port: {{ .Values.service.port }}",
      "      targetPort: http",
      "      protocol: TCP",
      "      name: http",
      "  selector:",
      "    {{- include \"chart.selectorLabels\" . | nindent 4 }}"
    })
  }),
  
  s("values", {
    t("{{ .Values."), i(1, "key"), t(" }}")
  }),
  
  s("chart", {
    t("{{ .Chart."), i(1, "Name"), t(" }}")
  }),
  
  s("release", {
    t("{{ .Release."), i(1, "Name"), t(" }}")
  })
})

-- Configure treesitter for better syntax highlighting
require('nvim-treesitter.configs').setup {
  ensure_installed = {
    "lua", "vim", "vimdoc", "json", "yaml", "cue", 
    "go", "gomod", "gosum", "gotmpl", "helm"
  },
  sync_install = false,
  auto_install = true,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = { "gotmpl", "helm" },
  },
  indent = {
    enable = true,
  },
}

return {}
