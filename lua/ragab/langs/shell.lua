-- Bash / sh / zsh: bash-language-server (runs shellcheck itself), shfmt on save.
return {
  indent = {
    sh = { tab = false, width = 2 }, -- matches shfmt -i 2
    bash = { tab = false, width = 2 },
    zsh = { tab = false, width = 2 },
  },

  parsers = { "bash" },

  servers = {
    bashls = {
      filetypes = { "sh", "bash", "zsh" },
      settings = {
        bashIde = {
          globPattern = "*@(.sh|.inc|.bash|.command|.zsh)",
          shellcheckArguments = "-x", -- follow `source`d files
        },
      },
    },
  },

  formatters = { sh = { "shfmt" }, bash = { "shfmt" } },
  formatter_opts = {
    shfmt = { prepend_args = { "-i", "2", "-ci", "-bn" } },
  },

  tools = { "bash-language-server", "shellcheck", "shfmt" },

  ftplugin = {
    filetypes = { "sh", "bash", "zsh" },
    setup = function(buf, map)
      local interp = vim.bo[buf].filetype == "zsh" and "zsh" or "bash"
      map("n", "<localleader>r", function()
        vim.cmd.write()
        require("ragab.util").run_in_terminal(interp .. " " .. vim.fn.shellescape(vim.api.nvim_buf_get_name(0)))
      end, "Shell: run file in terminal")
      map("n", "<localleader>x", "<cmd>!chmod +x %<cr>", "Shell: make executable")
    end,
  },
}
