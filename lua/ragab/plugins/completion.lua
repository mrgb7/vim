-- Completion (nvim-cmp + LuaSnip), autopairs and Copilot.
-- Function completions insert only the name (+ parentheses from autopairs): the
-- servers are configured not to send argument placeholders (see lua/ragab/langs).
-- <Tab> belongs to Copilot; snippets jump with <C-l> / <C-h>.
return {
  {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lsp-signature-help",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "saadparwaiz1/cmp_luasnip",
      "onsails/lspkind.nvim",
      {
        "L3MON4D3/LuaSnip",
        version = "v2.*",
        build = "make install_jsregexp",
        dependencies = { "rafamadriz/friendly-snippets" },
        config = function()
          require("luasnip.loaders.from_vscode").lazy_load()
        end,
      },
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-j>"] = cmp.mapping.select_next_item(),
          ["<C-k>"] = cmp.mapping.select_prev_item(),
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = false }),
          ["<C-l>"] = cmp.mapping(function(fallback)
            if luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<C-h>"] = cmp.mapping(function(fallback)
            if luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "nvim_lsp_signature_help" },
          { name = "luasnip" },
          { name = "path" },
        }, {
          { name = "buffer", keyword_length = 3 },
        }),
        formatting = {
          format = require("lspkind").cmp_format({ mode = "symbol_text", maxwidth = 50, ellipsis_char = "..." }),
        },
      })

      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = { { name = "buffer" } },
      })
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" } }),
        matching = { disallow_symbol_nonprefix_matching = false },
      })
    end,
  },

  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    dependencies = { "hrsh7th/nvim-cmp" },
    config = function()
      require("nvim-autopairs").setup({ check_ts = true })
      -- add () after confirming a function / method completion
      require("cmp").event:on("confirm_done", require("nvim-autopairs.completion.cmp").on_confirm_done())
    end,
  },

  {
    "github/copilot.vim",
    event = "InsertEnter",
    cmd = "Copilot",
    init = function()
      vim.g.copilot_no_tab_map = true
      vim.g.copilot_filetypes = { ["*"] = true }
      -- never send secrets / credentials to Copilot
      vim.api.nvim_create_autocmd("BufReadPre", {
        group = require("ragab.util").augroup("copilot_secrets"),
        pattern = {
          "*.env", ".env*", "*.envrc", "*secret*", "*.pem", "*.key", "*credentials*",
          "*kubeconfig*", "*/.kube/config", "*.tfvars",
        },
        callback = function()
          vim.b.copilot_enabled = false
        end,
      })
    end,
    config = function()
      local map = vim.keymap.set
      map("i", "<Tab>", 'copilot#Accept("\\t")', { expr = true, silent = true, replace_keycodes = false })
      map("i", "<M-Right>", "<Plug>(copilot-accept-word)", { desc = "Copilot: accept word" })
      map("i", "<M-]>", "<Plug>(copilot-next)", { desc = "Copilot: next suggestion" })
      map("i", "<M-[>", "<Plug>(copilot-previous)", { desc = "Copilot: prev suggestion" })
      map("i", "<C-]>", "<Plug>(copilot-dismiss)", { desc = "Copilot: dismiss" })
    end,
  },
}
