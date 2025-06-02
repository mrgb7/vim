-- Theme switcher functions

local M = {}

-- Function to set Catppuccin theme
function M.set_catppuccin(flavor)
    flavor = flavor or "mocha" -- Default to mocha if no flavor specified
    require('catppuccin').setup({
        flavour = flavor, -- latte, frappe, macchiato, mocha
        transparent_background = false,
        term_colors = true,
        integrations = {
            cmp = true,
            gitsigns = true,
            nvimtree = true,
            telescope = true,
            treesitter = true,
        },
    })
    vim.cmd.colorscheme "catppuccin"
    -- Update lualine theme
    require('lualine').setup {
        options = {
            theme = 'catppuccin'
        }
    }
end

-- Function to set Tokyo Night theme
function M.set_tokyonight(style)
    style = style or "storm" -- Default to storm if no style specified
    require("tokyonight").setup({
        style = style, -- storm, moon, night, day
        transparent = false,
        terminal_colors = true,
        styles = {
            comments = { italic = true },
            keywords = { italic = true },
            functions = {},
            variables = {},
            sidebars = "dark",
            floats = "dark",
        },
        sidebars = { "qf", "help", "terminal", "packer", "nvim-tree" },
        day_brightness = 0.3,
        hide_inactive_statusline = false,
        dim_inactive = false,
    })
    vim.cmd.colorscheme "tokyonight"
    -- Update lualine theme
    require('lualine').setup {
        options = {
            theme = 'tokyonight'
        }
    }
end

-- Function to set Nightfox theme
function M.set_nightfox(style)
    style = style or "nightfox" -- Default to nightfox if no style specified
    -- Available styles: nightfox, dayfox, dawnfox, duskfox, nordfox, terafox, carbonfox
    require('nightfox').setup({
        options = {
            transparent = false,
            terminal_colors = true,
            styles = {
                comments = "italic",
                keywords = "bold",
                types = "italic,bold",
            },
        }
    })
    vim.cmd("colorscheme " .. style)
    -- Update lualine theme
    require('lualine').setup {
        options = {
            theme = style
        }
    }
end

-- Create user commands for theme switching
vim.api.nvim_create_user_command('ThemeCatppuccin', function(opts)
    local flavor = opts.args ~= "" and opts.args or "mocha"
    M.set_catppuccin(flavor)
end, {
    nargs = '?',
    desc = 'Set Catppuccin theme (optional: latte, frappe, macchiato, mocha)',
    complete = function()
        return { "latte", "frappe", "macchiato", "mocha" }
    end,
})

vim.api.nvim_create_user_command('ThemeTokyonight', function(opts)
    local style = opts.args ~= "" and opts.args or "storm"
    M.set_tokyonight(style)
end, {
    nargs = '?',
    desc = 'Set Tokyo Night theme (optional: storm, moon, night, day)',
    complete = function()
        return { "storm", "moon", "night", "day" }
    end,
})

vim.api.nvim_create_user_command('ThemeNightfox', function(opts)
    local style = opts.args ~= "" and opts.args or "nightfox"
    M.set_nightfox(style)
end, {
    nargs = '?',
    desc = 'Set Nightfox theme (optional: nightfox, dayfox, dawnfox, duskfox, nordfox, terafox, carbonfox)',
    complete = function()
        return { "nightfox", "dayfox", "dawnfox", "duskfox", "nordfox", "terafox", "carbonfox" }
    end,
})

return M
