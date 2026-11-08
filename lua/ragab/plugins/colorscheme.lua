-- Catppuccin: latte when 'background' is light, mocha when dark (toggle: <leader>ub).
-- Go-specific captures are defined in after/queries/go/highlights.scm.
return {
  "catppuccin/nvim",
  name = "catppuccin",
  lazy = false,
  priority = 1000,
  opts = {
    flavour = "auto",
    background = { light = "latte", dark = "mocha" },
    styles = { comments = { "italic" } },
    auto_integrations = true, -- enables integrations for every installed plugin
    custom_highlights = function(c)
      return {
        ["@variable.go.err"] = { fg = c.red, bold = true }, -- follow error paths
        ["@function.go.exported"] = { fg = c.blue, bold = true }, -- public API
        ["@type.go.exported"] = { fg = c.yellow, bold = true },
        ["@type.go.interface"] = { fg = c.yellow, bold = true, italic = true },
        ["@string.go.tag"] = { fg = c.green, italic = true }, -- `json:"..."`
        ["@keyword.go.flow"] = { fg = c.mauve, bold = true }, -- go / defer
        ["@keyword.return"] = { fg = c.mauve, bold = true },
        ["@character.printf"] = { fg = c.peach, bold = true }, -- %v %s %w
      }
    end,
  },
  config = function(_, opts)
    require("catppuccin").setup(opts)
    vim.cmd.colorscheme("catppuccin")
  end,
}
