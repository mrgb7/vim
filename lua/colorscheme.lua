-- Configure themes and set default

-- Setup Catppuccin
local function setup_catppuccin()
  require("catppuccin").setup({
    flavour = "mocha", -- latte, frappe, macchiato, mocha
    background = { -- :h background
      light = "latte",
      dark = "mocha",
    },
    transparent_background = false,
    show_end_of_buffer = false,
    dim_inactive = {
      enabled = false,
    },
    styles = {
      comments = { "italic" },
      conditionals = { "italic" },
      loops = {},
      functions = {},
      keywords = {},
      strings = {},
      variables = {},
      numbers = {},
      booleans = {},
      properties = {},
      types = {},
      operators = {},
    },
    integrations = {
      cmp = true,
      gitsigns = true,
      nvimtree = true,
      telescope = true,
      treesitter = true,
      notify = false,
      mini = false,
    },
  })
  
  -- Set lualine theme
  require('lualine').setup {
    options = {
      theme = 'catppuccin'
    }
  }
end

-- Setup TokyoNight
local function setup_tokyonight()
  require("tokyonight").setup({
    style = "storm", -- The theme comes in three styles, `storm`, `moon`, a darker variant `night` and `day`
    transparent = false, -- Enable this to disable setting the background color
    terminal_colors = true, -- Configure the colors used when opening a `:terminal` in Neovim
    styles = {
      -- Style to be applied to different syntax groups
      comments = { italic = true },
      keywords = { italic = true },
      functions = {},
      variables = {},
      -- Background styles. Can be "dark", "transparent" or "normal"
      sidebars = "dark", -- style for sidebars, see below
      floats = "dark", -- style for floating windows
    },
    sidebars = { "qf", "help", "terminal", "packer", "nvim-tree" }, -- Set a darker background on sidebar-like windows
    day_brightness = 0.3, -- Adjusts the brightness of the colors of the **Day** style. Number between 0 and 1, from dull to vibrant colors
    hide_inactive_statusline = false, -- Enabling this option, will hide inactive statuslines and replace them with a thin border instead. Should work with the standard **StatusLine** and **LuaLine**.
    dim_inactive = false, -- dims inactive windows
    lualine_bold = false, -- When `true`, section headers in the lualine theme will be bold
  })
  
  -- Set lualine theme
  require('lualine').setup {
    options = {
      theme = 'tokyonight'
    }
  }
end

-- Setup Nightfox
local function setup_nightfox()
  require('nightfox').setup({
    options = {
      -- Compiled file's destination location
      compile_path = vim.fn.stdpath("cache") .. "/nightfox",
      compile_file_suffix = "_compiled", -- Compiled file suffix
      transparent = false,   -- Disable setting background
      terminal_colors = true, -- Set terminal colors (vim.g.terminal_color_*) used in `:terminal`
      dim_inactive = false,  -- Non focused panes set to alternative background
      styles = {            -- Style to be applied to different syntax groups
        comments = "italic", -- Value is any valid attr-list value `:help attr-list`
        conditionals = "NONE",
        constants = "NONE",
        functions = "NONE",
        keywords = "bold",
        numbers = "NONE",
        operators = "NONE",
        strings = "NONE",
        types = "italic,bold",
        variables = "NONE",
      },
      inverse = {          -- Inverse highlight for different types
        match_paren = false,
        visual = false,
        search = false,
      },
      modules = {         -- List of various plugins and additional options
        -- ...
      },
    },
  })
  
  -- Set lualine theme
  require('lualine').setup {
    options = {
      theme = 'nightfox'
    }
  }
end

-- Setup common commands for theme switching
vim.api.nvim_create_user_command('ThemeCatppuccin', function()
  setup_catppuccin()
  vim.cmd.colorscheme "catppuccin"
end, { desc = 'Set Catppuccin theme' })

vim.api.nvim_create_user_command('ThemeTokyonight', function()
  setup_tokyonight()
  vim.cmd.colorscheme "tokyonight"
end, { desc = 'Set Tokyo Night theme' })

vim.api.nvim_create_user_command('ThemeNightfox', function()
  setup_nightfox()
  vim.cmd.colorscheme "nightfox"
end, { desc = 'Set Nightfox theme' })

vim.api.nvim_create_user_command('ThemeDuskfox', function()
  setup_nightfox()
  vim.cmd.colorscheme "duskfox"
end, { desc = 'Set Duskfox theme' })

vim.api.nvim_create_user_command('ThemeNordfox', function()
  setup_nightfox()
  vim.cmd.colorscheme "nordfox"
end, { desc = 'Set Nordfox theme' })

vim.api.nvim_create_user_command('ThemeTerafox', function()
  setup_nightfox()
  vim.cmd.colorscheme "terafox"
end, { desc = 'Set Terafox theme' })

vim.api.nvim_create_user_command('ThemeCarbonfox', function()
  setup_nightfox()
  vim.cmd.colorscheme "carbonfox"
end, { desc = 'Set Carbonfox theme' })

-- Set default theme
setup_catppuccin()
vim.cmd.colorscheme "catppuccin"
