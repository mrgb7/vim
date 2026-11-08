-- LSP using the native Neovim 0.11+ API (vim.lsp.config / vim.lsp.enable).
-- nvim-lspconfig only supplies the default server definitions (its lsp/*.lua files);
-- per-server overrides come from lua/ragab/langs/*.lua.
local util = require("ragab.util")

local M = {}

local function on_attach(ev)
  local client = vim.lsp.get_client_by_id(ev.data.client_id)
  if not client then
    return
  end
  local buf = ev.buf
  local function map(mode, lhs, rhs, desc)
    util.map(mode, lhs, rhs, { buffer = buf, desc = desc })
  end

  -- navigation (Telescope pickers; a single result jumps directly)
  map("n", "gd", "<cmd>Telescope lsp_definitions<cr>", "Go to definition")
  map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
  map("n", "gR", "<cmd>Telescope lsp_references<cr>", "References")
  map("n", "gi", "<cmd>Telescope lsp_implementations<cr>", "Implementations")
  map("n", "gt", "<cmd>Telescope lsp_type_definitions<cr>", "Type definition")
  map("n", "K", function() vim.lsp.buf.hover({ border = "rounded" }) end, "Hover documentation")

  -- actions
  map({ "n", "x" }, "<leader>ca", vim.lsp.buf.code_action, "Code action")
  map("n", "<leader>rn", vim.lsp.buf.rename, "Rename symbol")
  map("n", "<leader>rs", "<cmd>LspRestart<cr>", "Restart LSP")

  -- symbols / call hierarchy / diagnostics
  map("n", "<leader>fo", "<cmd>Telescope lsp_document_symbols<cr>", "Document symbols")
  map("n", "<leader>fS", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", "Workspace symbols")
  map("n", "<leader>ci", "<cmd>Telescope lsp_incoming_calls<cr>", "Incoming calls")
  map("n", "<leader>co", "<cmd>Telescope lsp_outgoing_calls<cr>", "Outgoing calls")
  map("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<cr>", "Buffer diagnostics")

  if client:supports_method("textDocument/inlayHint") then
    map("n", "<leader>ih", function()
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = buf }), { bufnr = buf })
    end, "Toggle inlay hints")
  end

  -- code lenses (gopls: run test, go mod tidy, govulncheck, ...); run with <localleader>v in Go
  if client:supports_method("textDocument/codeLens") then
    if vim.lsp.codelens.enable then -- Neovim 0.12+
      vim.lsp.codelens.enable(true, { bufnr = buf })
    else -- Neovim 0.11
      vim.lsp.codelens.refresh({ bufnr = buf })
      vim.api.nvim_create_autocmd({ "BufEnter", "InsertLeave", "BufWritePost" }, {
        group = vim.api.nvim_create_augroup("ragab_lsp_codelens_" .. buf, { clear = true }),
        buffer = buf,
        callback = function()
          vim.lsp.codelens.refresh({ bufnr = buf })
        end,
      })
    end
  end

  -- highlight other references of the symbol under the cursor
  if client:supports_method("textDocument/documentHighlight") then
    local group = vim.api.nvim_create_augroup("ragab_lsp_highlight_" .. buf, { clear = true })
    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
      group = group,
      buffer = buf,
      callback = vim.lsp.buf.document_highlight,
    })
    vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI", "BufLeave" }, {
      group = group,
      buffer = buf,
      callback = vim.lsp.buf.clear_references,
    })
  end
end

---Configure and enable every server declared in lua/ragab/langs.
function M.setup()
  vim.api.nvim_create_autocmd("LspAttach", { group = util.augroup("lsp_attach"), callback = on_attach })

  vim.lsp.config("*", {
    capabilities = require("cmp_nvim_lsp").default_capabilities(),
  })

  local servers = require("ragab.langs").map("servers")
  for name, cfg in pairs(servers) do
    if type(cfg) == "function" then
      cfg = cfg() -- lazy configs (e.g. those that need schemastore)
    end
    if type(cfg) == "table" then
      vim.lsp.config(name, cfg)
    end
  end
  vim.lsp.enable(vim.tbl_keys(servers))
end

return M
