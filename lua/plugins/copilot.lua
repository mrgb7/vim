return {
  {
    "github/copilot.vim",
    event = "VimEnter",
    config = function()
      -- Disable default tab mapping (we'll use Tab in cmp)
      vim.g.copilot_no_tab_map = true

      -- Keybindings for Copilot using Vim commands (more reliable)
      vim.cmd([[
        imap <silent><script><expr> <C-j> copilot#Accept("")
        imap <silent> <C-l> <Plug>(copilot-next)
        imap <silent> <C-k> <Plug>(copilot-previous)
        imap <silent> <C-d> <Plug>(copilot-dismiss)
        imap <silent><script><expr> <Tab> copilot#Accept("\<CR>")
      ]])

      -- Set Node.js path (required for macOS)
      if vim.fn.executable("node") == 1 then
        vim.g.copilot_node_command = vim.fn.system("which node"):gsub("\n", "")
      end

      -- Optional: Set custom request timeout
      vim.g.copilot_request_timeout = 5

      -- Create toggle command for quick enable/disable
      vim.api.nvim_create_user_command("CopilotToggle", function()
        local status = vim.fn["copilot#Enabled"]()
        if status == 1 then
          vim.cmd("Copilot disable")
          print("Copilot disabled")
        else
          vim.cmd("Copilot enable")
          print("Copilot enabled")
        end
      end, {})

      -- Optional: Add a keybinding for quick toggle (change to your preferred key)
      vim.keymap.set("n", "<leader>ct", ":CopilotToggle<CR>", { noremap = true, silent = true })
    end,
  },
}
