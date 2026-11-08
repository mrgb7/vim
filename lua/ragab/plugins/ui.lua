-- Statusline, tabline, start screen, key hints and visual guides.
return {
  { "nvim-tree/nvim-web-devicons", lazy = true },

  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function()
      local function lsp_clients()
        local names = vim.tbl_map(function(c)
          return c.name
        end, vim.lsp.get_clients({ bufnr = 0 }))
        return #names > 0 and (" " .. table.concat(names, ",")) or ""
      end
      return {
        options = {
          theme = "auto",
          component_separators = "",
          section_separators = "",
          globalstatus = true,
          disabled_filetypes = { statusline = { "alpha" } },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff", "diagnostics" },
          lualine_c = { { "filename", path = 1, symbols = { modified = " ●", readonly = " " } } },
          lualine_x = { "searchcount", lsp_clients, "filetype" },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
        extensions = { "nvim-tree", "lazy", "mason", "trouble", "toggleterm", "quickfix", "nvim-dap-ui", "fugitive" },
      }
    end,
  },

  {
    "akinsho/bufferline.nvim",
    version = "*",
    event = "VeryLazy",
    dependencies = { "catppuccin" }, -- must load after the theme for correct highlights
    opts = function()
      return {
        highlights = require("catppuccin.special.bufferline").get_theme(),
        options = {
          mode = "tabs",
          separator_style = "slant",
          always_show_bufferline = false,
          diagnostics = "nvim_lsp",
          offsets = { { filetype = "NvimTree", text = "Explorer", separator = true } },
        },
      }
    end,
  },

  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "modern",
      spec = {
        { "<leader>b", group = "buffer" },
        { "<leader>c", group = "code" },
        { "<leader>d", group = "debug" },
        { "<leader>e", group = "explorer" },
        { "<leader>f", group = "find" },
        { "<leader>g", group = "git" },
        { "<leader>h", group = "harpoon" },
        { "<leader>l", group = "lint" },
        { "<leader>r", group = "rename / restart" },
        { "<leader>s", group = "split" },
        { "<leader>t", group = "tab / terminal" },
        { "<leader>u", group = "ui toggles" },
        { "<leader>w", group = "session" },
        { "<leader>x", group = "diagnostics" },
        { "<localleader>", group = "language" },
      },
    },
  },

  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    config = function()
      local dashboard = require("alpha.themes.dashboard")
      dashboard.section.header.val = {
        "                                                     ",
        "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
        "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
        "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
        "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
        "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
        "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
        "                                                     ",
      }
      dashboard.section.buttons.val = {
        dashboard.button("e", "  > New file", "<cmd>ene<cr>"),
        dashboard.button("SPC ee", "  > File explorer", "<cmd>NvimTreeToggle<cr>"),
        dashboard.button("SPC ff", "󰱼  > Find file", "<cmd>Telescope find_files<cr>"),
        dashboard.button("SPC fg", "  > Live grep", "<cmd>Telescope live_grep<cr>"),
        dashboard.button("SPC wr", "󰁯  > Restore session", "<cmd>AutoSession restore<cr>"),
        dashboard.button("q", "  > Quit", "<cmd>qa<cr>"),
      }
      require("alpha").setup(dashboard.opts)
    end,
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = { "BufReadPost", "BufNewFile" },
    opts = { indent = { char = "┊" } },
  },

  { "HiPhish/rainbow-delimiters.nvim", event = { "BufReadPost", "BufNewFile" } },

  -- colour column only on lines that are actually too long
  {
    "m4xshen/smartcolumn.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      colorcolumn = "100",
      custom_colorcolumn = { go = "120", gitcommit = "72" },
      disabled_filetypes = { "help", "text", "alpha", "NvimTree", "lazy", "mason", "trouble", "toggleterm" },
    },
  },
}
