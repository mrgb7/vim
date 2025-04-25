-- LSP configuration
require('mason').setup()
require('mason-lspconfig').setup {
  ensure_installed = { 'gopls', 'pyright', 'bashls' }
}

local lspconfig = require('lspconfig')
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Configure LSP servers with formatting
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Diagnostic keymaps
  vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic' })
  vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic' })
  vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic error messages' })
  vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic quickfix list' })

  -- LSP keymaps
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { desc = 'Go to declaration', buffer = bufnr })
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = 'Go to definition', buffer = bufnr })
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = 'Hover Documentation', buffer = bufnr })
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, { desc = 'Go to implementation', buffer = bufnr })
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, { desc = 'Signature Documentation', buffer = bufnr })
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { desc = 'Rename', buffer = bufnr })
  vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { desc = 'Code actions', buffer = bufnr })
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, { desc = 'Go to references', buffer = bufnr })

  -- Telescope LSP keymaps (more user friendly)
  local builtin = require('telescope.builtin')
  vim.keymap.set('n', '<leader>gd', builtin.lsp_definitions, { desc = 'Telescope: Go to definition', buffer = bufnr })
  vim.keymap.set('n', '<leader>gr', builtin.lsp_references, { desc = 'Telescope: Find references', buffer = bufnr })
  vim.keymap.set('n', '<leader>gi', builtin.lsp_implementations, { desc = 'Telescope: Go to implementation', buffer = bufnr })
  vim.keymap.set('n', '<leader>gs', builtin.lsp_document_symbols, { desc = 'Telescope: Document symbols', buffer = bufnr })
  vim.keymap.set('n', '<leader>gw', builtin.lsp_workspace_symbols, { desc = 'Telescope: Workspace symbols', buffer = bufnr })

  -- Format on save
  if client.server_capabilities.documentFormattingProvider then
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = bufnr,
      callback = function()
        -- For Go files, special handling to ensure imports are properly managed
        if vim.bo[bufnr].filetype == "go" then
          -- Organize imports - this explicitly asks gopls to add missing imports and remove unused ones
          local params = vim.lsp.util.make_range_params()
          params.context = { only = {"source.organizeImports"} }
          
          -- Request the imports to be organized
          local result = vim.lsp.buf_request_sync(bufnr, "textDocument/codeAction", params, 3000)
          for _, res in pairs(result or {}) do
            for _, r in pairs(res.result or {}) do
              if r.edit then
                vim.lsp.util.apply_workspace_edit(r.edit, "UTF-8")
              elseif r.command then
                vim.lsp.buf.execute_command(r.command)
              end
            end
          end
        end
        
        -- Standard format
        vim.lsp.buf.format({ bufnr = bufnr })
      end,
    })
  end
end

-- Configure gopls with formatting and enhanced diagnostics
lspconfig.gopls.setup {
  capabilities = capabilities,
  on_attach = on_attach,
  settings = {
    gopls = {
      analyses = {
        unusedparams = true,
        shadow = true,        -- Check for shadowed variables
        unusedwrite = true,   -- Check for unused writes
        useany = true,        -- Check for constraints that could be relaxed
        unusedvariable = true, -- Add this to detect unused variables
      },
      staticcheck = true,
      gofumpt = true,
      usePlaceholders = true,
      completeUnimported = true,
      experimentalPostfixCompletions = true,
      
      -- This is crucial for auto-imports and unused import removal
      codelenses = {
        gc_details = true,
        generate = true,
        regenerate_cgo = true,
        run_govulncheck = true,
        test = true,
        tidy = true,
        upgrade_dependency = true,
        vendor = true,
      },
      
      hints = {
        assignVariableTypes = true,
        compositeLiteralFields = true,
        compositeLiteralTypes = true,
        constantValues = true,
        functionTypeParameters = true,
        parameterNames = true,
        rangeVariableTypes = true,
      },
    },
  },
}

-- Configure other LSP servers
lspconfig.pyright.setup {
  capabilities = capabilities,
  on_attach = on_attach,
}

lspconfig.bashls.setup {
  capabilities = capabilities,
  on_attach = on_attach,
}


-- Telescope configuration
require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      },
    },
  },
}

-- Keymaps configuration
-- Space is already our leader key from init.lua

-- Telescope keymaps
local builtin = require('telescope.builtin')
-- Find files (Space + ff)
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Find files' })
-- Live grep (Space + fg)
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Live grep' })
-- Find in open buffers (Space + fb)
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Find buffers' })
-- Find help tags (Space + fh)
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Help tags' })
-- Git files (Space + gf)
vim.keymap.set('n', '<leader>gf', builtin.git_files, { desc = 'Git files' })

-- Autocompletion setup
local cmp = require('cmp')
cmp.setup {
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  }, {
    { name = 'buffer' },
  })
}

-- Configure Tokyo Night theme
require("tokyonight").setup({
  style = "night",
  light_style = "day",
  transparent = false,
  terminal_colors = true,
  day_brightness = 0.3,
  hide_inactive_statusline = false,
  dim_inactive = false,
  lualine_bold = false,

  --- You can override specific color groups to use other groups or a hex color
  on_colors = function(colors)
    colors.bg = "#1a1b26"
    colors.bg_dark = "#16161e"
    colors.bg_float = "#16161e"
    colors.bg_highlight = "#292e42"
    colors.bg_popup = "#16161e"
    colors.bg_search = "#3d59a1"
    colors.bg_sidebar = "#16161e"
    colors.bg_statusline = "#16161e"
    colors.bg_visual = "#283457"
    colors.border = "#15161e"
    colors.fg = "#c0caf5"
    colors.fg_dark = "#a9b1d6"
    colors.fg_gutter = "#3b4261"
    colors.fg_sidebar = "#a9b1d6"
    colors.comment = "#565f89"
    colors.blue = "#7aa2f7"
    colors.cyan = "#7dcfff"
    colors.blue1 = "#2ac3de"
    colors.blue2 = "#0db9d7"
    colors.blue5 = "#89ddff"
    colors.blue6 = "#b4f9f8"
    colors.magenta = "#bb9af7"
    colors.magenta2 = "#ff007c"
    colors.purple = "#9d7cd8"
    colors.orange = "#ff9e64"
    colors.yellow = "#e0af68"
    colors.green = "#9ece6a"
    colors.green1 = "#73daca"
    colors.green2 = "#41a6b5"
    colors.teal = "#1abc9c"
    colors.red = "#f7768e"
    colors.red1 = "#db4b4b"
  end,
})

-- Configure status line
local status, lualine = pcall(require, 'lualine')
if status then
  lualine.setup {
    options = {
      theme = 'tokyonight',
      component_separators = { left = '', right = ''},
      section_separators = { left = '', right = ''},
    },
  }
else
  print("Lualine plugin not found. Run :PackerInstall to install it.")
end

-- Configure indent guides (version 3.x syntax)
require("ibl").setup {
  indent = {
    char = "│",
  },
  scope = {
    enabled = true,
    show_start = true,
    show_end = false,
  },
}

-- Cursor configuration
vim.opt.guicursor = "n-v-c:block-Cursor,i-ci-ve:ver25-Cursor,r-cr-o:hor20-Cursor"
vim.api.nvim_set_hl(0, "Cursor", { fg = "#1a1b26", bg = "#c0caf5" })
vim.api.nvim_set_hl(0, "iCursor", { fg = "#1a1b26", bg = "#c0caf5" })
vim.opt.cursorline = true -- Highlight the current line
vim.api.nvim_set_hl(0, "CursorLine", { bg = "#292e42" })

-- Set colorscheme after plugins are loaded
vim.cmd('colorscheme tokyonight')

-- Configure auto-pairs
require('nvim-autopairs').setup({
  check_ts = true,
  ts_config = {
    lua = {'string'},
    javascript = {'template_string'},
    java = false,
  },
})

-- Add auto-pairs completion to nvim-cmp
local cmp_autopairs = require('nvim-autopairs.completion.cmp')
local cmp = require('cmp')
cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())

-- Configure diagnostics appearance
vim.diagnostic.config({
  virtual_text = true,  -- Show errors beside the code
  signs = true,         -- Show signs in the sign column
  underline = true,     -- Underline errors
  update_in_insert = true,
  severity_sort = true,
  float = {
    border = 'rounded',
    source = 'always',
    header = '',
    prefix = '',
  },
})

-- Change diagnostic symbols in the sign column
local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- Configure macOS specific keymaps for navigation
-- Option (Alt) + Left/Right for word jump
vim.keymap.set('n', '˙', 'b', { desc = 'Jump word backward' })  -- Option + h
vim.keymap.set('n', '¬', 'w', { desc = 'Jump word forward' })   -- Option + l
vim.keymap.set('i', '˙', '<C-o>b', { desc = 'Jump word backward' })  -- Option + h
vim.keymap.set('i', '¬', '<C-o>w', { desc = 'Jump word forward' })   -- Option + l

-- Option + Left/Right arrow keys
vim.keymap.set('n', '<M-Left>', 'b', { desc = 'Jump word backward' })
vim.keymap.set('n', '<M-Right>', 'w', { desc = 'Jump word forward' })
vim.keymap.set('i', '<M-Left>', '<C-o>b', { desc = 'Jump word backward' })
vim.keymap.set('i', '<M-Right>', '<C-o>w', { desc = 'Jump word forward' })

-- Fast navigation
vim.keymap.set('n', '<C-d>', '<C-d>zz', { desc = 'Move half page down and center' })
vim.keymap.set('n', '<C-u>', '<C-u>zz', { desc = 'Move half page up and center' })
vim.keymap.set('n', 'G', 'Gzz', { desc = 'Jump to end of file and center' })
vim.keymap.set('n', 'gg', 'ggzz', { desc = 'Jump to start of file and center' })
vim.keymap.set('n', 'n', 'nzzzv', { desc = 'Next search result and center' })
vim.keymap.set('n', 'N', 'Nzzzv', { desc = 'Previous search result and center' })

-- Line navigation
vim.keymap.set('n', 'H', '^', { desc = 'Go to start of line' })
vim.keymap.set('n', 'L', '$', { desc = 'Go to end of line' })

-- Buffer management keymaps
-- Close current buffer
vim.keymap.set('n', '<leader>x', ':bd<CR>', { desc = 'Close current buffer', silent = true })
-- Close current buffer without saving
vim.keymap.set('n', '<leader>X', ':bd!<CR>', { desc = 'Force close current buffer', silent = true })
-- Save and close current buffer
vim.keymap.set('n', '<leader>w', ':w<CR>', { desc = 'Save current buffer', silent = true })
-- Switch between buffers
vim.keymap.set('n', '<Tab>', ':bnext<CR>', { desc = 'Next buffer', silent = true })
vim.keymap.set('n', '<S-Tab>', ':bprevious<CR>', { desc = 'Previous buffer', silent = true })
-- List all buffers with Telescope
vim.keymap.set('n', '<leader>fb', ':Telescope buffers<CR>', { desc = 'Find open buffers', silent = true })

-- Fast vertical navigation
-- Move half page up/down and center cursor
vim.keymap.set('n', '<C-d>', '<C-d>zz', { desc = 'Move half page down and center' })
vim.keymap.set('n', '<C-u>', '<C-u>zz', { desc = 'Move half page up and center' })

-- Move 5 lines up/down
vim.keymap.set('n', '<C-j>', '5j', { desc = 'Move 5 lines down' })
vim.keymap.set('n', '<C-k>', '5k', { desc = 'Move 5 lines up' })

-- Smooth scrolling with <C-e> and <C-y>
vim.keymap.set('n', '<C-e>', '3<C-e>', { desc = 'Scroll down 3 lines' })
vim.keymap.set('n', '<C-y>', '3<C-y>', { desc = 'Scroll up 3 lines' })

-- Jump paragraphs and center
vim.keymap.set('n', '}', '}zz', { desc = 'Jump to next paragraph and center' })
vim.keymap.set('n', '{', '{zz', { desc = 'Jump to previous paragraph and center' })

-- Go-specific keybindings
vim.api.nvim_create_autocmd("FileType", {
  pattern = "go",
  callback = function()
    local bufnr = vim.api.nvim_get_current_buf()
    -- Add import organization keybinding for Go files
    vim.keymap.set('n', '<leader>gi', function()
      -- Organize imports - requests gopls to add missing imports and remove unused ones
      local params = vim.lsp.util.make_range_params()
      params.context = { only = {"source.organizeImports"} }
      
      -- Request the imports to be organized
      local result = vim.lsp.buf_request_sync(bufnr, "textDocument/codeAction", params, 3000)
      for _, res in pairs(result or {}) do
        for _, r in pairs(res.result or {}) do
          if r.edit then
            vim.lsp.util.apply_workspace_edit(r.edit, "UTF-8")
          elseif r.command then
            vim.lsp.buf.execute_command(r.command)
          end
        end
      end
      
      -- Notify the user
      vim.notify("Go imports organized", vim.log.levels.INFO)
    end, { desc = 'Organize Go imports', buffer = bufnr })
  end
})

-- Verify gopls is working correctly on startup
vim.api.nvim_create_autocmd("User", {
  pattern = "LspAttached",
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client.name == "gopls" then
      vim.notify("gopls attached with auto-imports enabled", vim.log.levels.INFO)
    end
  end
})

-- Create the LspAttached event when an LSP attaches
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    vim.api.nvim_exec_autocmds("User", { pattern = "LspAttached", data = args })
  end
})
