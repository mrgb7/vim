-- Ensure matching brackets are clearly highlighted
local function set_matchparen_highlight()
  -- Bold + underline stands out regardless of theme
  vim.api.nvim_set_hl(0, "MatchParen", { bold = true, underline = true })
end

set_matchparen_highlight()

-- Re-apply after colorscheme changes
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = set_matchparen_highlight,
  desc = "Ensure MatchParen highlight persists across colorscheme changes",
})

