-- Small helpers shared by the whole config.
local M = {}

M.mason_bin = vim.fn.stdpath("data") .. "/mason/bin"

---Create (and clear) a namespaced augroup.
---@param name string
---@return integer
function M.augroup(name)
  return vim.api.nvim_create_augroup("ragab_" .. name, { clear = true })
end

---vim.keymap.set with `silent = true` by default; `opts` may be just a description.
---@param mode string|string[]
---@param lhs string
---@param rhs string|function
---@param opts? string|table
function M.map(mode, lhs, rhs, opts)
  opts = type(opts) == "string" and { desc = opts } or vim.deepcopy(opts or {})
  if opts.silent == nil then
    opts.silent = true
  end
  vim.keymap.set(mode, lhs, rhs, opts)
end

---Is one of `names` present in `path` or any parent directory?
---@param names string[]
---@param path string
function M.has_upward(names, path)
  return vim.fs.find(names, { upward = true, path = path })[1] ~= nil
end

---Flip a boolean and report it.
---@param label string
---@param get fun(): boolean
---@param set fun(value: boolean)
function M.toggle(label, get, set)
  local value = not get()
  set(value)
  vim.notify(label .. " " .. (value and "on" or "off"))
end

---Run a shell command in a dedicated toggleterm (terminal #9, bottom split).
---@param cmd string
function M.run_in_terminal(cmd)
  require("toggleterm").exec(cmd, 9, 15, nil, "horizontal")
end

return M
