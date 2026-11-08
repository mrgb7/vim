-- Debugging: delve for Go (nvim-dap-go), codelldb for C / C++ (build with -g -O0).
local function dap(fn, ...)
  local args = { ... }
  return function()
    require("dap")[fn](unpack(args))
  end
end

return {
  "mfussenegger/nvim-dap",
  dependencies = {
    { "rcarriga/nvim-dap-ui", dependencies = { "nvim-neotest/nvim-nio" } },
    "theHamsta/nvim-dap-virtual-text",
    "leoluz/nvim-dap-go",
  },
  keys = {
    { "<leader>db", dap("toggle_breakpoint"), desc = "Toggle breakpoint" },
    {
      "<leader>dB",
      function() require("dap").set_breakpoint(vim.fn.input("Condition: ")) end,
      desc = "Conditional breakpoint",
    },
    { "<leader>dc", dap("continue"), desc = "Continue / start" },
    { "<leader>di", dap("step_into"), desc = "Step into" },
    { "<leader>do", dap("step_over"), desc = "Step over" },
    { "<leader>dO", dap("step_out"), desc = "Step out" },
    { "<leader>dC", dap("run_to_cursor"), desc = "Run to cursor" },
    { "<leader>dl", dap("run_last"), desc = "Run last" },
    { "<leader>dq", dap("terminate"), desc = "Terminate" },
    { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Toggle REPL" },
    { "<leader>du", function() require("dapui").toggle() end, desc = "Toggle DAP UI" },
    { "<leader>de", function() require("dapui").eval() end, mode = { "n", "x" }, desc = "Eval expression" },
    { "<leader>dt", function() require("dap-go").debug_test() end, desc = "Debug Go test" },
    { "<leader>dT", function() require("dap-go").debug_last_test() end, desc = "Debug last Go test" },
  },
  config = function()
    local d = require("dap")
    local dapui = require("dapui")

    require("dap-go").setup()
    require("nvim-dap-virtual-text").setup({})
    dapui.setup()

    d.adapters.codelldb = { type = "executable", command = "codelldb" } -- from Mason
    d.configurations.c = {
      {
        name = "Launch executable",
        type = "codelldb",
        request = "launch",
        program = function()
          return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
        end,
        args = function()
          return vim.split(vim.fn.input("Args: "), " ", { trimempty = true })
        end,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
      },
      {
        name = "Attach to process",
        type = "codelldb",
        request = "attach",
        pid = require("dap.utils").pick_process,
        cwd = "${workspaceFolder}",
      },
    }
    d.configurations.cpp = d.configurations.c

    vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError" })
    vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "DiagnosticWarn" })
    vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DiagnosticOk", linehl = "Visual" })

    d.listeners.after.event_initialized.dapui = dapui.open
    d.listeners.before.event_terminated.dapui = dapui.close
    d.listeners.before.event_exited.dapui = dapui.close
  end,
}
