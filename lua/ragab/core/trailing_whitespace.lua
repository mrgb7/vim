-- Enable trailing whitespace highlighting for markdown files
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    -- Create highlight group for trailing whitespace using Catppuccin red
    vim.cmd([[highlight TrailingWhitespace guibg=#f38ba8 guifg=#f38ba8]])

    -- Enable syntax highlighting for trailing whitespace in markdown files
    vim.cmd([[syntax match TrailingWhitespace /\s\+$/ containedin=ALL]])
  end,
})