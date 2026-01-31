return {
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("nvim-tree").setup({
        view = {
          width = 30,
        },
        renderer = {
          icons = {
            show = {
              file = true,
              folder = true,
              folder_arrow = true,
              git = true,
            }
          }
        },
        filters = {
          dotfiles = false,
          git_ignored = false,
        },
        git = {
          enable = true,
          ignore = false,
        }
      })

      -- Toggle tree with Ctrl+n
      local api = require("nvim-tree.api")
      vim.keymap.set("n", "<C-n>", api.tree.toggle, { noremap = true, silent = true })

      -- Focus/navigate to tree with Ctrl+t
      vim.keymap.set("n", "<C-t>", function()
        api.tree.focus()
      end, { noremap = true, silent = true })
    end
  }
}
