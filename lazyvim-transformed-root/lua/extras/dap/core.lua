-- Dependencies: Neovim 0.12.6; Git for vim.pack; nvim-dap; nvim-dap-ui; nvim-nio; nvim-dap-virtual-text; plenary.nvim; adapters installed manually per language.
-- Docs: https://github.com/mfussenegger/nvim-dap
-- Enable: require("extras.dap.core") in init.lua.
-- Load BEFORE any language module defining dap.adapters/configurations, and before extras.dap.nlua.
-- Install each debugger manually; this module never installs/builds one. Debug runs launch programs and can have project side effects.
-- VS Code launch.json support is native to nvim-dap; commented JSON decoding uses plenary.json.
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).

vim.pack.add({
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/nvim-neotest/nvim-nio",
  "https://github.com/mfussenegger/nvim-dap",
  "https://github.com/rcarriga/nvim-dap-ui",
  "https://github.com/theHamsta/nvim-dap-virtual-text",
})
local dap, ui = require("dap"), require("dapui")
ui.setup({})
require("nvim-dap-virtual-text").setup({})
vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })
for name, sign in pairs(require("config.icons").dap) do
  sign = type(sign) == "table" and sign or { sign }
  vim.fn.sign_define("Dap" .. name, { text = sign[1], texthl = sign[2] or "DiagnosticInfo", linehl = sign[3] })
end
require("dap.ext.vscode").json_decode = function(str)
  return vim.json.decode(require("plenary.json").json_strip_comments(str))
end
dap.listeners.after.event_initialized["config_dap_ui"] = function()
  ui.open()
end
dap.listeners.before.event_terminated["config_dap_ui"] = function()
  ui.close()
end
dap.listeners.before.event_exited["config_dap_ui"] = function()
  ui.close()
end
local map = vim.keymap.set
map("n", "<leader>dB", function()
  dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
end, { desc = "Conditional breakpoint" })
map("n", "<leader>da", function()
  dap.continue({
    before = function(config)
      config = vim.deepcopy(config)
      local args = type(config.args) == "function" and config.args() or config.args or {}
      local text = vim.fn.input("Run with args: ", type(args) == "table" and table.concat(args, " ") or args)
      config.args = config.type == "java" and text or require("dap.utils").splitstr(text)
      return config
    end,
  })
end, { desc = "Debug with arguments" })
for key, action in pairs({
  db = "toggle_breakpoint",
  dc = "continue",
  dC = "run_to_cursor",
  dg = "goto_",
  di = "step_into",
  dj = "down",
  dk = "up",
  dl = "run_last",
  do_ = "step_out",
  dO = "step_over",
  dP = "pause",
  dt = "terminate",
}) do
  map("n", "<leader>" .. key:gsub("_$", ""), function()
    dap[action]()
  end, { desc = "Debug: " .. action })
end
map("n", "<leader>dr", function()
  dap.repl.toggle()
end, { desc = "Debug REPL" })
map("n", "<leader>ds", function()
  require("dap.ui.widgets").sidebar(require("dap.ui.widgets").sessions):open()
end, { desc = "Debug sessions" })
map("n", "<leader>dw", function()
  require("dap.ui.widgets").hover()
end, { desc = "Debug hover" })
map("n", "<leader>du", function()
  ui.toggle()
end, { desc = "Debug UI" })
map({ "n", "x" }, "<leader>de", function()
  ui.eval()
end, { desc = "Debug evaluate" })
