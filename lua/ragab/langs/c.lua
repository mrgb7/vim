-- C / C++ / eBPF, plus the build files around them (Make, CMake, linker scripts).
--
-- clangd reads compile flags from compile_commands.json (`bear -- make`,
-- `cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON`) or a compile_flags.txt / .clangd.
-- Formatting is opt-in: clang-format only runs when the project ships a
-- .clang-format, so a kernel / libbpf tree is never reformatted by accident.
local has_upward = require("ragab.util").has_upward

---Formatters for a C/C++ buffer: clang-format only inside a project that has a
---.clang-format. lsp_format = "never" so it never falls back to clangd formatting.
local function clang_format(buf)
  local dir = vim.fs.dirname(vim.api.nvim_buf_get_name(buf))
  local enabled = has_upward({ ".clang-format", "_clang-format" }, dir)
  return { enabled and "clang_format" or nil, lsp_format = "never" }
end

return {
  indent = {
    c = { tab = true, width = 8 }, -- kernel / libbpf style
    cpp = { tab = true, width = 8 },
    make = { tab = true, width = 8 }, -- Makefiles require tabs
    cmake = { tab = false, width = 2 },
  },

  detect = {
    filename = { ["compile_flags.txt"] = "conf" },
    extension = { bpf = "c", lds = "ld" },
  },

  parsers = {
    "c", "cpp", "make", "cmake", "asm", "objdump", "disassembly", "linkerscript",
    "kconfig", "devicetree", "strace", "printf",
  },

  servers = {
    clangd = {
      cmd = {
        "clangd",
        "--background-index",
        "--clang-tidy",
        "--header-insertion=never", -- don't auto-add #includes (breaks vmlinux.h-style BPF code)
        "--completion-style=detailed",
        "--function-arg-placeholders=0", -- complete `printf` without argument placeholders
        "--fallback-style=llvm",
        "--offset-encoding=utf-16",
      },
      root_markers = {
        ".clangd", "compile_commands.json", "compile_flags.txt", ".clang-tidy", ".clang-format", "Makefile", ".git",
      },
    },
    neocmake = true,
  },

  formatters = {
    c = clang_format,
    cpp = clang_format,
    cmake = { "cmake_format" },
  },

  tools = { "clangd", "clang-format", "codelldb", "neocmakelsp", "cmakelang" },

  ftplugin = {
    filetypes = { "c", "cpp" },
    setup = function(buf, map)
      -- :make parses gcc/clang errors into the quickfix list
      vim.api.nvim_buf_call(buf, function()
        vim.cmd.compiler("gcc")
      end)
      map("n", "<localleader>h", "<cmd>ClangdSwitchSourceHeader<cr>", "C: switch source/header")
      map("n", "<localleader>s", "<cmd>ClangdSymbolInfo<cr>", "C: symbol info")
      map("n", "<localleader>t", "<cmd>ClangdTypeHierarchy<cr>", "C: type hierarchy")
      map("n", "<localleader>a", "<cmd>ClangdAST<cr>", "C: show AST")
      map("n", "<localleader>b", "<cmd>make! | cwindow<cr>", "C: build (make)")
    end,
  },

  plugins = {
    -- clangd extras: AST, type hierarchy, symbol info, inlay hints
    { "p00f/clangd_extensions.nvim", ft = { "c", "cpp" }, opts = {} },
  },
}
