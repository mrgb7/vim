return {
  "github/copilot.vim",
  event = "VeryLazy",
  cmd = "Copilot",
  config = function()
    -- Disable default Tab mapping so we can customize it
    vim.g.copilot_no_tab_map = true

    -- Delete any existing Tab mapping in insert mode
    pcall(vim.keymap.del, "i", "<Tab>")

    -- Accept suggestion with Tab using Copilot's recommended approach
    vim.keymap.set("i", "<Tab>", 'copilot#Accept("\\t")', {
      expr = true,
      silent = true,
      replace_keycodes = false,
      script = true,
    })

    -- Cycle through suggestions with Alt+] and Alt+[
    vim.keymap.set("i", "<M-]>", "<Plug>(copilot-next)", { silent = true })
    vim.keymap.set("i", "<M-[>", "<Plug>(copilot-previous)", { silent = true })

    -- Dismiss suggestion with Ctrl+]
    vim.keymap.set("i", "<C-]>", "<Plug>(copilot-dismiss)", { silent = true })

    -- Enable Copilot for all filetypes
    vim.g.copilot_filetypes = {
      ["*"] = true,
      yaml = true,
      markdown = true,
    }
  end,
}
