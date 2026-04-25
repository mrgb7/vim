return {
  {
    "catppuccin/nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha",
        background = {
          dark = "mocha",
        },
        transparent_background = false,
        dim_inactive = {
          enabled = true,
          percentage = 0.12,
        },
        styles = {
          comments = { "italic" },
          keywords = { "bold" },
          functions = { "bold" },
          types = { "bold", "italic" },
        },
        integrations = {
          telescope = { enabled = true, style = "nvchad" },
          treesitter = true,
          gitsigns = true,
          indent_blankline = {
            enabled = true,
            colored_indent_levels = false,
          },
          lsp_trouble = true,
          which_key = true,
          native_lsp = {
            enabled = true,
            underlines = {
              errors = { "undercurl" },
              hints = { "undercurl" },
              warnings = { "undercurl" },
              information = { "undercurl" },
            },
          },
          bufferline = true,
          cmp = true,
          harpoon = true,
          markdown = true,
        },
      })

      vim.cmd("colorscheme catppuccin")
    end,
  },
}
