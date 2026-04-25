return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local status_ok, lualine = pcall(require, "lualine")
    if not status_ok then
      return
    end
    local lazy_status = require("lazy.status")

    -- "auto" will set the theme dynamically based on the colorscheme
    lualine.setup({
      options = {
        theme = "auto",
      },
      sections = {
        lualine_x = {
          {
            lazy_status.updates,
            cond = lazy_status.has_updates,
            color = { fg = "#ff9e64" },
          },
          { "encoding" },
          { "fileformat" },
          { "filetype" },
        },
      },
    })
  end,
}
