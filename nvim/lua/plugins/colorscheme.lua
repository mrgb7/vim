return {
  -- macOS-like light theme with multiple options
  {
    "folke/tokyonight.nvim",
    enabled = false, -- Disabled in favor of Catppuccin
    lazy = false,
    priority = 1000,
    config = function()
      require("tokyonight").setup({
        style = "night",
        light_style = "day",
        transparent = false,
        terminal_colors = true,
        styles = {
          comments = { italic = true },
          keywords = { italic = true },
          functions = {},
          variables = {},
          sidebars = "dark",
          floats = "normal",
        },
        sidebars = { "qf", "help", "NvimTree" },
        hide_inactive_statusline = false,
        dim_inactive = false,
        lualine_bold = true,
      })
      vim.cmd([[colorscheme tokyonight-night]])
    end,
  },

  -- Alternative: Catppuccin Latte (also very macOS-like)
  {
    "catppuccin/nvim",
    name = "catppuccin",
    enabled = true, -- Now enabled as primary theme
    lazy = false,
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha", -- mocha is the dark theme
        background = {
          light = "latte",
          dark = "mocha",
        },
        transparent_background = false,
        show_end_of_buffer = false,
        term_colors = true,
        dim_inactive = {
          enabled = false,
          shade = "dark",
          percentage = 0.15,
        },
        no_italic = true,
        no_bold = false,
        no_underline = false,
        color_overrides = {
          latte = {
            base = "#ffffff",     -- Pure white background
            mantle = "#f8f9fa",   -- Very light gray
            crust = "#f0f0f0",    -- Light gray
          },
        },
        integrations = {
          cmp = true,
          gitsigns = true,
          nvimtree = true,
          treesitter = true,
          telescope = {
            enabled = true,
          },
          which_key = true,
        },
      })
      vim.cmd([[colorscheme catppuccin-mocha]])
    end,
  },

  -- Alternative: GitHub theme (very clean and light)
  {
    "projekt0n/github-nvim-theme",
    enabled = false, -- Disabled by default
    priority = 1000,
    config = function()
      require("github-theme").setup({
        options = {
          compile_path = vim.fn.stdpath("cache") .. "/github-theme",
          compile_file_suffix = "_compiled",
          hide_end_of_buffer = true,
          hide_nc_statusline = true,
          transparent = false,
          terminal_colors = true,
          dim_inactive = false,
          module_default = true,
          styles = {
            comments = "NONE",
            functions = "NONE",
            keywords = "NONE",
            variables = "NONE",
            conditionals = "NONE",
            constants = "NONE",
            numbers = "NONE",
            operators = "NONE",
            strings = "NONE",
            types = "NONE",
          },
          inverse = {
            match_paren = false,
            visual = false,
            search = false,
          },
        },
      })
      vim.cmd([[colorscheme github_light_default]])
    end,
  },
}