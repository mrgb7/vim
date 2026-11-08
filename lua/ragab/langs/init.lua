-- Language registry.
--
-- Every file in this directory describes ONE language (or a family of related
-- filetypes). The plugin specs read from it, so adding a language means adding
-- one file here and listing it below. Nothing else needs to change.
--
-- A language module returns a table with any of these fields:
--
--   detect      vim.filetype.add() spec               (core, at startup)
--   indent      { [ft] = { tab = bool, width = n } }  (core, on FileType)
--   ftplugin    { filetypes = {...}, setup = fun(buf, map) }  buffer-local maps/options
--   parsers     treesitter parsers                    -> plugins/treesitter.lua
--   servers     { [name] = true | vim.lsp.Config | fun(): vim.lsp.Config }  -> lua/ragab/lsp.lua
--   formatters  conform formatters_by_ft              -> plugins/format.lua
--   formatter_opts  conform `formatters` overrides     -> plugins/format.lua
--   linters     nvim-lint linters_by_ft               -> plugins/lint.lua
--   lint_condition  { [ft] = fun(buf): boolean }       -> plugins/lint.lua (skip linting when false)
--   tools       Mason package names                   -> plugins/lsp.lua
--   plugins     extra lazy.nvim specs                 -> plugins/langs.lua
local M = {}

M.enabled = {
  "go",
  "c", -- C, C++, CMake, Make, assembly
  "shell",
  "yaml", -- YAML, Helm, GitHub Actions, docker-compose
  "json",
  "python",
  "docker",
  "terraform",
  "proto",
  "toml",
  "lua",
  "markdown",
}

local cache
---@return table[]
function M.all()
  if not cache then
    cache = vim.tbl_map(function(name)
      return require("ragab.langs." .. name)
    end, M.enabled)
  end
  return cache
end

---Concatenate a list field (deduplicated, order preserved) across all languages.
---@param field string
---@return string[]
function M.list(field)
  local seen, out = {}, {}
  for _, lang in ipairs(M.all()) do
    for _, item in ipairs(lang[field] or {}) do
      if not seen[item] then
        seen[item] = true
        out[#out + 1] = item
      end
    end
  end
  return out
end

---Merge a map field across all languages (later languages win on conflicts).
---@param field string
---@return table
function M.map(field)
  local out = {}
  for _, lang in ipairs(M.all()) do
    out = vim.tbl_extend("force", out, lang[field] or {})
  end
  return out
end

---All extra plugin specs declared by languages.
function M.plugins()
  local specs = {}
  for _, lang in ipairs(M.all()) do
    vim.list_extend(specs, lang.plugins or {})
  end
  return specs
end

local function apply_indent(buf, cfg)
  local bo = vim.bo[buf]
  bo.expandtab = not cfg.tab
  bo.tabstop = cfg.width
  bo.shiftwidth = cfg.width
  bo.softtabstop = cfg.tab and 0 or cfg.width
  if cfg.tab then
    -- tabs are expected here: don't render them with the global "» " listchar
    vim.api.nvim_buf_call(buf, function()
      vim.opt_local.listchars:append({ tab = "  " })
    end)
  end
end

---Called once from init.lua: filetype detection, indentation, buffer-local setup.
function M.setup()
  local augroup = require("ragab.util").augroup
  local indent = M.map("indent")

  for _, lang in ipairs(M.all()) do
    if lang.detect then
      vim.filetype.add(lang.detect)
    end
  end

  -- an .editorconfig in the project still wins: it is applied after FileType
  vim.api.nvim_create_autocmd("FileType", {
    group = augroup("lang_indent"),
    pattern = vim.tbl_keys(indent),
    callback = function(ev)
      apply_indent(ev.buf, indent[ev.match])
    end,
  })

  local group = augroup("lang_ftplugin")
  for _, lang in ipairs(M.all()) do
    local ftp = lang.ftplugin
    if ftp then
      vim.api.nvim_create_autocmd("FileType", {
        group = group,
        pattern = ftp.filetypes,
        callback = function(ev)
          local function map(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = ev.buf, silent = true, desc = desc })
          end
          ftp.setup(ev.buf, map)
        end,
      })
    end
  end
end

return M
