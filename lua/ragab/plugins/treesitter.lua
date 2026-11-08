-- nvim-treesitter has two incompatible branches:
--   main   -> Neovim >= 0.12 (parsers via the plugin, features via vim.treesitter)
--   master -> Neovim 0.11   (frozen, classic `nvim-treesitter.configs` API)
-- The branch matching the running Neovim is used, so this works on 0.11.4 and 0.12.
-- Parsers per language come from lua/ragab/langs.
local parsers = require("ragab.langs").list("parsers")

-- the regex indent scripts are better than the treesitter indent queries for these
local no_ts_indent = { "yaml", "python", "markdown" }

local context = {
  -- sticky header with the current function / struct while scrolling long files
  "nvim-treesitter/nvim-treesitter-context",
  event = { "BufReadPost", "BufNewFile" },
  opts = { max_lines = 3, multiline_threshold = 1 },
  keys = {
    { "<leader>uc", function() require("treesitter-context").toggle() end, desc = "Toggle sticky context" },
  },
}

if vim.fn.has("nvim-0.12") == 1 then
  return {
    {
      "nvim-treesitter/nvim-treesitter",
      branch = "main",
      lazy = false, -- main branch does not support lazy-loading
      build = ":TSUpdate",
      config = function()
        local ts = require("nvim-treesitter")
        ts.setup({})
        -- installs missing parsers in the background (needs the tree-sitter CLI)
        ts.install(parsers)

        -- incremental selection is built in on 0.12: `an` / `in` in visual mode
        vim.api.nvim_create_autocmd("FileType", {
          group = require("ragab.util").augroup("treesitter"),
          callback = function(ev)
            local lang = vim.treesitter.language.get_lang(ev.match) or ev.match
            if not pcall(vim.treesitter.start, ev.buf, lang) then
              return -- no parser for this filetype
            end
            if not vim.tbl_contains(no_ts_indent, lang) then
              vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            end
          end,
        })
      end,
    },
    context,
  }
end

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "TSInstall", "TSUpdate", "TSInstallInfo" },
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = parsers,
        auto_install = true,
        highlight = { enable = true },
        indent = { enable = true, disable = no_ts_indent },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<C-space>",
            node_incremental = "<C-space>",
            scope_incremental = false,
            node_decremental = "<bs>",
          },
        },
      })
    end,
  },
  context,
}
