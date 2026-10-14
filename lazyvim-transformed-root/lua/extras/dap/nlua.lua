-- Dependencies: Neovim 0.12.6; Git for vim.pack; one-small-step-for-vimkind; nvim-dap from extras.dap.core; nvim executable.
-- Docs: https://github.com/jbyuki/one-small-step-for-vimkind
-- Enable: require("extras.dap.nlua") in init.lua.
-- Load AFTER require("extras.dap.core"). Starts or attaches to a Neovim Lua debugger only when requested.
-- To debug another editor: run :lua require('osv').launch({port=8086}) there, then choose Attach here.
-- Derived from LazyVim; modified for standalone Neovim 0.12.6 (Apache-2.0).

-- Load the Lua debugger bridge; the DAP core is initialized by the preceding module.
vim.pack.add({ "https://github.com/jbyuki/one-small-step-for-vimkind" })
local dap = require("dap")
-- Resolve an attach request to a TCP debug server, with localhost:8086 as the default.
dap.adapters.nlua = function(callback, config)
  callback({ type = "server", host = config.host or "127.0.0.1", port = config.port or 8086 })
end
-- Offer an attach configuration for another Neovim instance that has started the debugger.
dap.configurations.lua = {
  { type = "nlua", request = "attach", name = "Attach to Neovim (port 8086)", port = 8086 },
}
-- Start debugging the current Lua file only when this mapping is invoked.
vim.keymap.set("n", "<leader>dL", function()
  require("osv").run_this()
end, { desc = "Debug this Neovim Lua file" })
