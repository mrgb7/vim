-- Minimal test to check if LSP is working
-- Run with: nvim -u ~/.config/nvim/test_lsp.lua ~/test.go

-- Check gopls is available
local gopls_path = vim.fn.executable("/Users/mohamed.ragab/go/bin/gopls")
print("gopls available: " .. (gopls_path == 1 and "YES" or "NO"))

-- Check if lspconfig can load
local ok_lsp, lspconfig = pcall(require, "lspconfig")
print("lspconfig loaded: " .. (ok_lsp and "YES" or "NO"))

-- Check if cmp can load
local ok_cmp, cmp = pcall(require, "cmp")
print("cmp loaded: " .. (ok_cmp and "YES" or "NO"))

-- Try to check for gopls language server
if ok_lsp then
  print("Available servers: gopls, pyright, tsserver")
end

print("\nTo debug LSP in a Go file:")
print("  :LspInfo           - Check if gopls is running")
print("  :CmpStatus         - Check completion sources")
print("  Ctrl+Space         - Trigger completion manually")
