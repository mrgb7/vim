-- Entry point. Load order matters:
--   1. core   : leader, options, keymaps, autocmds, diagnostics (no plugins needed)
--   2. langs  : filetype detection + per-language indentation (data-driven, see lua/ragab/langs)
--   3. lazy   : bootstrap lazy.nvim and load every spec under lua/ragab/plugins
require("ragab.core")
require("ragab.langs").setup()
require("ragab.core.lazy")
